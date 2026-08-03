import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// সার্ভিস যা FCM পুষ্প নোটিফিকেশন রিসিভ, টপিক সাবস্ক্রিপশন এবং পার-ইউজার রিড স্ট্যাটাস পরিচালনা করে।
class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _readIdsKey = 'user_read_notification_ids';

  /// FCM মেসেজিং ইনিশিয়ালাইজেশন ও অল ইউজার টপিক সাবস্ক্রিপশন
  static Future<void> initialize() async {
    try {
      if (kIsWeb) {
        // On Web, request permission asynchronously with timeout so app never blocks loading
        _fcm.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        ).timeout(const Duration(seconds: 3)).then((settings) {
          if (kDebugMode) {
            print('FCM Web Authorization status: ${settings.authorizationStatus}');
          }
          _fcm.subscribeToTopic('all_users').catchError((_) {});
        }).catchError((e) {
          if (kDebugMode) {
            print('FCM Web permission non-blocking notice: $e');
          }
        });
        return;
      }

      // 1. Request Notification Permissions for Mobile
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (kDebugMode) {
        print('FCM Authorization status: ${settings.authorizationStatus}');
      }

      // 2. Subscribe to universal 'all_users' topic
      await _fcm.subscribeToTopic('all_users');

      // 3. Foreground messaging listener
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          print('Foreground FCM Message received: ${message.notification?.title}');
        }
      });

      // 4. Background app opened listener
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (kDebugMode) {
          print('App opened from FCM notification: ${message.notification?.title}');
        }
      });

    } catch (e) {
      if (kDebugMode) {
        print('FCM Initialization error: $e');
      }
    }
  }

  /// লোকাল SharedPreferences থেকে পঠিত নোটিফিকেশন ID সমূহের সেট পাওয়া
  static Future<Set<String>> getReadNotificationIds() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? list = prefs.getStringList(_readIdsKey);
    return list != null ? list.toSet() : <String>{};
  }

  /// নোটিফিকেশনকে 'পঠিত' (Read) হিসেবে চিহ্নিত করা
  static Future<void> markAsRead(String notificationId) async {
    if (notificationId.isEmpty) return;

    // 1. Store in local SharedPreferences for instant UI update & offline support
    final prefs = await SharedPreferences.getInstance();
    final Set<String> currentReadIds = await getReadNotificationIds();
    currentReadIds.add(notificationId);
    await prefs.setStringList(_readIdsKey, currentReadIds.toList());

    // 2. If user is logged in, sync to Firestore `users/{uid}/read_notifications/{notificationId}`
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('read_notifications')
            .doc(notificationId)
            .set({
          'readAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        if (kDebugMode) {
          print('Error syncing read status to Firestore: $e');
        }
      }
    }
  }

  /// সকল নোটিফিকেশনকে 'পঠিত' হিসেবে চিহ্নিত করা
  static Future<void> markAllAsRead(List<String> notificationIds) async {
    if (notificationIds.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final Set<String> currentReadIds = await getReadNotificationIds();
    currentReadIds.addAll(notificationIds);
    await prefs.setStringList(_readIdsKey, currentReadIds.toList());

    final user = _auth.currentUser;
    if (user != null) {
      final batch = _firestore.batch();
      for (final id in notificationIds) {
        final docRef = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('read_notifications')
            .doc(id);
        batch.set(docRef, {'readAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
      }
      try {
        await batch.commit();
      } catch (e) {
        if (kDebugMode) {
          print('Error batch syncing read status: $e');
        }
      }
    }
  }

  /// নির্দিষ্ট নোটিফিকেশন পঠিত কিনা তা চেক করা
  static Future<bool> isRead(String notificationId) async {
    final Set<String> readIds = await getReadNotificationIds();
    return readIds.contains(notificationId);
  }

  /// রিয়েল-টাইম অপঠিত (Unread) নোটিফিকেশন গণনার জন্য স্ট্রিম
  static Stream<int> getUnreadCountStream() {
    return _firestore
        .collection('notifications')
        .snapshots()
        .asyncMap((snapshot) async {
      final readIds = await getReadNotificationIds();
      int unreadCount = 0;
      for (var doc in snapshot.docs) {
        if (!readIds.contains(doc.id)) {
          unreadCount++;
        }
      }
      return unreadCount;
    });
  }
}

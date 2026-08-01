import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// অফলাইন কুইক ডাটা কিউ এবং ফায়ারস্টোর অটো-সিঙ্ক ম্যানেজার
class OfflineSyncManager {
  static const String _pendingQueueKey = 'offline_pending_sync_queue';
  static final ValueNotifier<int> pendingCountNotifier = ValueNotifier<int>(0);

  /// অফলাইনে থাকাকালীন কোনো এন্ট্রি সেভ হলে পেন্ডিং কিউতে যোগ করা
  static Future<void> enqueueTask(Map<String, dynamic> task) async {
    final prefs = await SharedPreferences.getInstance();
    final queueJson = prefs.getStringList(_pendingQueueKey) ?? [];
    queueJson.add(jsonEncode({
      ...task,
      'createdAt': DateTime.now().toIso8601String(),
    }));
    await prefs.setStringList(_pendingQueueKey, queueJson);
    pendingCountNotifier.value = queueJson.length;
  }

  /// অফলাইনে অপেক্ষমাণ কতগুলো আইটেম আছে তার সংখ্যা
  static Future<int> getPendingTaskCount() async {
    final prefs = await SharedPreferences.getInstance();
    final queueJson = prefs.getStringList(_pendingQueueKey) ?? [];
    pendingCountNotifier.value = queueJson.length;
    return queueJson.length;
  }

  /// অনলাইনে আসার সাথে সাথেই ফায়ারস্টোরে অটোমেটিক সিঙ্ক সম্পন্ন করা
  static Future<void> syncPendingQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final queueJson = prefs.getStringList(_pendingQueueKey) ?? [];
    if (queueJson.isEmpty) {
      pendingCountNotifier.value = 0;
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    List<String> remainingQueue = [];

    for (final rawTask in queueJson) {
      try {
        final task = jsonDecode(rawTask) as Map<String, dynamic>;
        final type = task['type'] as String?;

        if (type == 'personal_entry') {
          final dateKey = task['date'] as String;
          final entryData = task['data'] as Map<String, dynamic>;
          final yearMonth = dateKey.length >= 7 ? dateKey.substring(0, 7) : dateKey;

          // 1. Indivual daily entry doc
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('personal_reports')
              .doc(dateKey)
              .set(entryData, SetOptions(merge: true));

          // 2. Bundled monthly document in users/{userId}/monthly_reports/{year_month}
          await syncMonthlyReportDoc(
            userId: user.uid,
            yearMonth: yearMonth,
            dateKey: dateKey,
            entryData: entryData,
          );
        } else if (type == 'monthly_plan') {
          final yearMonth = task['yearMonth'] as String;
          final planData = task['data'] as Map<String, dynamic>;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('monthly_plans')
              .doc(yearMonth)
              .set(planData, SetOptions(merge: true));
        } else if (type == 'zonal_report') {
          final yearMonth = task['yearMonth'] as String;
          final zonalData = task['data'] as Map<String, dynamic>;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('zonal_reports')
              .doc(yearMonth)
              .set(zonalData, SetOptions(merge: true));
        } else if (type == 'baytulmal_report') {
          final yearMonth = task['yearMonth'] as String;
          final data = task['data'] as Map<String, dynamic>;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('baytulmal_reports')
              .doc(yearMonth)
              .set(data, SetOptions(merge: true));
        }
      } catch (e) {
        print('Offline sync error: $e');
        remainingQueue.add(rawTask);
      }
    }

    await prefs.setStringList(_pendingQueueKey, remainingQueue);
    pendingCountNotifier.value = remainingQueue.length;
  }

  /// প্রতিটি ইউজারের প্রতিটি মাসের রিপোর্ট যেন একটি ডকুমেন্টের আকারে ফায়ারস্টোরে সেভ থাকে
  /// Path: users/{userId}/monthly_reports/{year_month}
  static Future<void> syncMonthlyReportDoc({
    required String userId,
    required String yearMonth,
    required String dateKey,
    required Map<String, dynamic> entryData,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('monthly_reports')
          .doc(yearMonth);

      final parts = yearMonth.split('-');
      final year = parts.isNotEmpty ? (int.tryParse(parts[0]) ?? DateTime.now().year) : DateTime.now().year;
      final month = parts.length > 1 ? (int.tryParse(parts[1]) ?? DateTime.now().month) : DateTime.now().month;

      await docRef.set({
        'userId': userId,
        'yearMonth': yearMonth,
        'year': year,
        'month': month,
        'lastUpdatedAt': FieldValue.serverTimestamp(),
        'dailyEntries': {
          dateKey: entryData,
        },
      }, SetOptions(merge: true));
    } catch (e) {
      print('Monthly report document save error: $e');
    }
  }
}

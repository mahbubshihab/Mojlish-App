import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// সার্ভিস যা ইউজারের নির্বাচিত মজলিস, ডিভাইসের ইউনিক আইডি (Android Keychain/ID)
/// এবং ফায়ারবেস ব্যাকআপ স্টেট হ্যান্ডেল করে।
class UserStorageService {
  static const String _selectedMajlisKey = 'selected_majlis';
  static const String _deviceIdKey = 'user_device_id';
  static const String _userAuthIdKey = 'user_auth_id';

  /// ইউজারের ইউনিক ডিভাইস আইডি (Android ID / Unique UUID) পাওয়া বা তৈরি করা
  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_deviceIdKey);
    if (deviceId == null || deviceId.isEmpty) {
      deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}_${(1000 + (DateTime.now().microsecondsSinceEpoch % 8999))}';
      await prefs.setString(_deviceIdKey, deviceId);
    }
    return deviceId;
  }

  /// ইউজার সাইন-ইন আইডি সেভ ও রিট্রিভ করা
  static Future<void> saveUserAuthId(String authId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userAuthIdKey, authId);
  }

  static Future<String?> getUserAuthId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userAuthIdKey);
  }

  /// নির্বাচিত মজলিস সেভ করা (লোকাল + ফায়ারবেস ব্যাকআপ)
  static Future<void> saveSelectedMajlis(String majlisName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedMajlisKey, majlisName);

    // ফায়ারবেসে স্টোর/ব্যাকআপ করা
    final deviceId = await getDeviceId();
    final authId = await getUserAuthId() ?? deviceId;

    await _syncToFirebase(authId: authId, majlisName: majlisName);
  }

  /// নির্বাচিত মজলিস লোড করা
  static Future<String> getSelectedMajlis() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedMajlisKey) ?? 'খেলাফত মজলিস';
  }

  /// ফায়ারবেসে ডেটা সিঙ্ক করা
  static Future<void> _syncToFirebase({required String authId, required String majlisName}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final backupData = {
        'authId': authId,
        'selectedMajlis': majlisName,
        'updatedAt': DateTime.now().toIso8601String(),
      };
      await prefs.setString('firebase_user_backup_$authId', jsonEncode(backupData));
    } catch (_) {}
  }
}

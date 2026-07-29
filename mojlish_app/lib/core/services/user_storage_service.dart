import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// সার্ভিস যা ইউজারের নির্বাচিত মজলিস, ইমেইল, ফটো ইউআরএল এবং ফায়ারবেস ব্যাকআপ হ্যান্ডেল করে।
class UserStorageService {
  static const String _selectedMajlisKey = 'selected_majlis';
  static const String _deviceIdKey = 'user_device_id';
  static const String _userAuthIdKey = 'user_auth_id';
  static const String _userNameKey = 'user_display_name';
  static const String _userEmailKey = 'user_email';
  static const String _userPhotoUrlKey = 'user_photo_url';

  /// ইউজারের ইউনিক ডিভাইস আইডি পাওয়া বা তৈরি করা
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

  /// ইউজারের নাম সেভ করা
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final trimmedName = name.trim();
    final finalName = trimmedName.isEmpty ? 'মিজানুর রহমান' : trimmedName;
    await prefs.setString(_userNameKey, finalName);

    final deviceId = await getDeviceId();
    final authId = await getUserAuthId() ?? deviceId;
    final majlis = await getSelectedMajlis();

    await _syncToFirebase(authId: authId, majlisName: majlis, userName: finalName);
  }

  /// ইউজারের নাম রিট্রিভ করা (ডিফল্ট: 'মিজানুর রহমান')
  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString(_userNameKey);
    if (savedName == null || savedName.trim().isEmpty) {
      return 'মিজানুর রহমান';
    }
    return savedName;
  }

  /// ইউজারের ইমেইল সেভ ও রিট্রিভ করা
  static Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email.trim());
  }

  static Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey) ?? '';
  }

  /// ইউজারের ফটো ইউআরএল (অবতার) সেভ ও রিট্রিভ করা
  static Future<void> saveUserPhotoUrl(String photoUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userPhotoUrlKey, photoUrl.trim());
  }

  static Future<String> getUserPhotoUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPhotoUrlKey) ?? '';
  }

  /// নির্বাচিত মজলিস সেভ করা
  static Future<void> saveSelectedMajlis(String majlisName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedMajlisKey, majlisName);

    final deviceId = await getDeviceId();
    final authId = await getUserAuthId() ?? deviceId;
    final userName = await getUserName();

    await _syncToFirebase(authId: authId, majlisName: majlisName, userName: userName);
  }

  /// নির্বাচিত মজলিস লোড করা
  static Future<String> getSelectedMajlis() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedMajlisKey) ?? 'খেলাফত মজলিস';
  }

  /// Alias for active majlis
  static Future<String?> getActiveMajlis() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedMajlisKey);
  }

  static Future<void> saveActiveMajlis(String majlisName) async {
    await saveSelectedMajlis(majlisName);
  }

  /// ইউজার সংক্রান্ত সকল লোকাল স্টোরেজ ক্লিয়ার করা
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// ইউজার পূর্বে কোনো মজলিস সিলেক্ট করেছে কিনা চেক করা
  static Future<bool> hasSavedMajlis() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_selectedMajlisKey);
    return saved != null && saved.isNotEmpty;
  }

  /// ফায়ারবেসে ডেটা সিঙ্ক করা
  static Future<void> _syncToFirebase({
    required String authId,
    required String majlisName,
    String? userName,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentBackupStr = prefs.getString('firebase_user_backup_$authId');
      Map<String, dynamic> backupData = {};
      if (currentBackupStr != null) {
        try {
          backupData = jsonDecode(currentBackupStr) as Map<String, dynamic>;
        } catch (_) {}
      }
      backupData['authId'] = authId;
      backupData['selectedMajlis'] = majlisName;
      if (userName != null) {
        backupData['userName'] = userName;
      }
      backupData['updatedAt'] = DateTime.now().toIso8601String();
      await prefs.setString('firebase_user_backup_$authId', jsonEncode(backupData));
    } catch (_) {}
  }
}

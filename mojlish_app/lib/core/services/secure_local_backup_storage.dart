import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// টেকসই ও নিরাপদ লোকাল ব্যাকআপ স্টোরেজ — App Documents Directory Backup
/// কোনো অবস্থাতেই যেন ক্যাশ ক্লিয়ার বা অপটিমাইজার অ্যাপ লোকাল ডাটা ডিলিট না করতে পারে
class SecureLocalBackupStorage {
  static const String _backupFileName = 'mojlish_secure_data_backup.json';

  static Future<File> _getBackupFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_backupFileName');
  }

  /// নির্দিষ্ট কোনো কী-এর ডাটা টেকসই ফাইলেই ব্যাকআপ রাখা
  static Future<void> backupKeyData(String key, dynamic data) async {
    try {
      final file = await _getBackupFile();
      Map<String, dynamic> allBackup = {};
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          allBackup = jsonDecode(content) as Map<String, dynamic>;
        }
      }
      allBackup[key] = data;
      await file.writeAsString(jsonEncode(allBackup), flush: true);
    } catch (e) {
      debugPrint('SecureLocalBackupStorage backup error: $e');
    }
  }

  /// টেকসই ফাইল থেকে কোনো নির্দিষ্ট কী-এর ডাটা পুনরুদ্ধার (Recover) করা
  static Future<dynamic> recoverKeyData(String key) async {
    try {
      final file = await _getBackupFile();
      if (!await file.exists()) return null;
      final content = await file.readAsString();
      if (content.isEmpty) return null;
      final allBackup = jsonDecode(content) as Map<String, dynamic>;
      return allBackup[key];
    } catch (e) {
      debugPrint('SecureLocalBackupStorage recovery error: $e');
      return null;
    }
  }

  /// সম্পূর্ণ ব্যাকআপ ফাইল পড়া
  static Future<Map<String, dynamic>> readAllBackup() async {
    try {
      final file = await _getBackupFile();
      if (!await file.exists()) return {};
      final content = await file.readAsString();
      if (content.isEmpty) return {};
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('SecureLocalBackupStorage read error: $e');
      return {};
    }
  }
}

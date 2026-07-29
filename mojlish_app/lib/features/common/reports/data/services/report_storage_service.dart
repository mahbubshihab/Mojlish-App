import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/daily_personal_entry.dart';

/// লোকাল স্টোরেজ ও ফায়ারস্টোর সিঙ্ক সার্ভিস — SharedPreferences ও Cloud Firestore
class ReportStorageService {
  static const String _personalReportKey = 'personal_reports';

  // ===========================
  // ব্যক্তিগত রিপোর্ট — CRUD & Offline Firestore Sync
  // ===========================

  static Future<void> savePersonalEntry(DailyPersonalEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final allData = await getAllPersonalEntries();
    allData[entry.date] = entry;
    final encoded = allData.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_personalReportKey, jsonEncode(encoded));

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('personal_reports')
            .doc(entry.date)
            .set(entry.toJson(), SetOptions(merge: true));
      }
    } catch (e) {
      print('Firestore sync error: $e');
    }
  }

  static Future<Map<String, DailyPersonalEntry>> getAllPersonalEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_personalReportKey);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (k, v) => MapEntry(k, DailyPersonalEntry.fromJson(v as Map<String, dynamic>)),
    );
  }

  static Future<DailyPersonalEntry?> getPersonalEntry(String date) async {
    final all = await getAllPersonalEntries();
    return all[date];
  }

  static Future<List<DailyPersonalEntry>> getPersonalEntriesInRange(
    DateTime from,
    DateTime to,
  ) async {
    final all = await getAllPersonalEntries();
    final result = <DailyPersonalEntry>[];
    DateTime current = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day);
    while (!current.isAfter(end)) {
      final key = _dateKey(current);
      if (all.containsKey(key)) result.add(all[key]!);
      current = current.add(const Duration(days: 1));
    }
    return result;
  }

  static Future<int> getFilledDaysCount(int year, int month) async {
    final all = await getAllPersonalEntries();
    int count = 0;
    for (final key in all.keys) {
      try {
        final d = DateTime.parse(key);
        if (d.year == year && d.month == month && !all[key]!.isEmpty) count++;
      } catch (_) {}
    }
    return count;
  }

  // ===========================
  // Utility
  // ===========================

  static String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  static String dateKey(DateTime date) => _dateKey(date);
}

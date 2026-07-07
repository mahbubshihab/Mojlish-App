import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_personal_entry.dart';
import '../models/baytulmal_report_entry.dart';
import '../models/monthly_comment.dart';
import '../models/sanghotonik_report_entry.dart';
import '../models/zonal_report_entry.dart';

/// লোকাল স্টোরেজ সার্ভিস — SharedPreferences দিয়ে রিপোর্ট সেভ ও লোড করে
class ReportStorageService {
  static const String _personalReportKey = 'personal_reports';
  static const String _baytulmalReportKey = 'baytulmal_reports';
  static const String _sanghotonikReportKey = 'sanghotonik_reports';
  static const String _zonalReportKey = 'zonal_reports';
  static const String _commentsKey = 'monthly_comments';

  // ===========================
  // ব্যক্তিগত রিপোর্ট — CRUD
  // ===========================

  static Future<void> savePersonalEntry(DailyPersonalEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final allData = await getAllPersonalEntries();
    allData[entry.date] = entry;
    final encoded = allData.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_personalReportKey, jsonEncode(encoded));
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
  // বায়তুলমাল রিপোর্ট — CRUD
  // ===========================

  static Future<void> saveBaytulmalEntry(BaytulmalReportEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final allData = await getAllBaytulmalEntries();
    final key = '${entry.year}-${entry.month}';
    allData[key] = entry;
    final encoded = allData.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_baytulmalReportKey, jsonEncode(encoded));
  }

  static Future<Map<String, BaytulmalReportEntry>> getAllBaytulmalEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_baytulmalReportKey);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (k, v) => MapEntry(k, BaytulmalReportEntry.fromJson(v as Map<String, dynamic>)),
    );
  }

  static Future<BaytulmalReportEntry?> getBaytulmalEntry(int year, int month) async {
    final all = await getAllBaytulmalEntries();
    final key = '$year-${month.toString().padLeft(2, '0')}';
    return all[key];
  }

  // ===========================
  // সাংগঠনিক রিপোর্ট — CRUD
  // ===========================

  static Future<void> saveSanghotonikEntry(SanghotonikReportEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final allData = await getAllSanghotonikEntries();
    final key = '${entry.year}-${entry.month}';
    allData[key] = entry;
    final encoded = allData.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_sanghotonikReportKey, jsonEncode(encoded));
  }

  static Future<Map<String, SanghotonikReportEntry>> getAllSanghotonikEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sanghotonikReportKey);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (k, v) => MapEntry(k, SanghotonikReportEntry.fromJson(v as Map<String, dynamic>)),
    );
  }

  static Future<SanghotonikReportEntry?> getSanghotonikEntry(int year, int month) async {
    final all = await getAllSanghotonikEntries();
    final key = '$year-${month.toString().padLeft(2, '0')}';
    return all[key];
  }

  // ===========================
  // জোনাল রিপোর্ট — CRUD
  // ===========================

  static Future<void> saveZonalEntry(ZonalReportEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final allData = await getAllZonalEntries();
    final key = '${entry.year}-${entry.month}';
    allData[key] = entry;
    final encoded = allData.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_zonalReportKey, jsonEncode(encoded));
  }

  static Future<Map<String, ZonalReportEntry>> getAllZonalEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_zonalReportKey);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (k, v) => MapEntry(k, ZonalReportEntry.fromJson(v as Map<String, dynamic>)),
    );
  }

  static Future<ZonalReportEntry?> getZonalEntry(int year, int month) async {
    final all = await getAllZonalEntries();
    final key = '$year-${month.toString().padLeft(2, '0')}';
    return all[key];
  }

  // ===========================
  // মাসিক মন্তব্য — CRUD
  // ===========================

  static Future<void> saveComment(MonthlyComment comment) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await _getAllComments();
    all[comment.id] = comment;
    final encoded = all.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_commentsKey, jsonEncode(encoded));
  }

  static Future<void> deleteComment(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await _getAllComments();
    all.remove(id);
    final encoded = all.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_commentsKey, jsonEncode(encoded));
  }

  static Future<List<MonthlyComment>> getCommentsForMonth(int year, int month) async {
    final all = await _getAllComments();
    final yearMonth = '$year-${month.toString().padLeft(2, '0')}';
    final result = all.values
        .where((c) => c.yearMonth == yearMonth)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return result;
  }

  static Future<Map<String, MonthlyComment>> _getAllComments() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_commentsKey);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (k, v) => MapEntry(k, MonthlyComment.fromJson(v as Map<String, dynamic>)),
    );
  }

  // ===========================
  // Utility
  // ===========================

  static String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  static String dateKey(DateTime date) => _dateKey(date);
}

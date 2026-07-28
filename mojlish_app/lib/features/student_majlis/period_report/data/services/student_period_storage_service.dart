import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/period_report_model.dart';

/// ছাত্র মজলিস বার্ষিক/ষান্মাসিক/দ্বি-মাসিক রিপোর্ট লোকাল স্টোরেজ সার্ভিস
class StudentPeriodStorageService {
  static const String _storageKey = 'student_period_reports';

  /// নির্দিষ্ট সময়ের রিপোর্ট লোড করা
  static Future<StudentPeriodReportModel> getReport({
    required String periodType,
    required int year,
    required String periodName,
  }) async {
    final all = await getAllReports();
    final keyId = '${periodType}_${year}_${periodName.replaceAll(' ', '_')}';
    if (all.containsKey(keyId)) {
      return all[keyId]!;
    }
    return StudentPeriodReportModel.empty(
      periodType: periodType,
      year: year,
      periodName: periodName,
    );
  }

  /// রিপোর্ট সংরক্ষণ করা
  static Future<void> saveReport(StudentPeriodReportModel report) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await getAllReports();
    all[report.id] = report;
    final encoded = all.map((key, val) => MapEntry(key, val.toJson()));
    await prefs.setString(_storageKey, jsonEncode(encoded));
  }

  /// সকল সংরক্ষিত রিপোর্ট পাওয়া
  static Future<Map<String, StudentPeriodReportModel>> getAllReports() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
        (key, value) => MapEntry(
          key,
          StudentPeriodReportModel.fromJson(value as Map<String, dynamic>),
        ),
      );
    } catch (_) {
      return {};
    }
  }
}

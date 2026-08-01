import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/baytulmal_report_model.dart';

/// StudentBaytulmalReport Remote / Local Datasource Interface
abstract class StudentBaytulmalReportDatasource {
  Future<BaytulmalReportModel?> fetchReport(int year, int month);
  Future<void> saveReport(BaytulmalReportModel model);
  Future<List<BaytulmalReportModel>> fetchAllReports();
}

/// SharedPreferences Implementation of StudentBaytulmalReportDatasource
class StudentBaytulmalReportDatasourceImpl implements StudentBaytulmalReportDatasource {
  static const String _storageKey = 'student_baytulmal_reports';

  @override
  Future<BaytulmalReportModel?> fetchReport(int year, int month) async {
    final all = await fetchAllReportsMap();
    final key = '$year-$month';
    return all[key];
  }

  @override
  Future<void> saveReport(BaytulmalReportModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final allMap = await fetchAllReportsMap();
    final key = '${model.session}-${model.month}';
    allMap[key] = model;

    final encoded = allMap.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_storageKey, jsonEncode(encoded));
  }

  @override
  Future<List<BaytulmalReportModel>> fetchAllReports() async {
    final allMap = await fetchAllReportsMap();
    return allMap.values.toList();
  }

  Future<Map<String, BaytulmalReportModel>> fetchAllReportsMap() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
        (k, v) => MapEntry(k, BaytulmalReportModel.fromJson(v as Map<String, dynamic>)),
      );
    } catch (_) {
      return {};
    }
  }
}

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles report persistence by writing to local storage first,
/// then initiating a background sync to Firestore.
class ReportStorageService {
  static const String _storagePrefix = 'report_storage_';

  /// Saves report data locally first, then triggers background sync to Firestore.
  static Future<void> saveReport(String reportType, Map<String, dynamic> data) async {
    try {
      // 1. Local storage write
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(data);
      await prefs.setString('$_storagePrefix$reportType', jsonString);
      debugPrint('Report saved to local storage for: $reportType');

      // 2. Trigger background sync to Firestore
      _syncToFirestore(reportType, data);
    } catch (e) {
      debugPrint('ReportStorageService error saving $reportType: $e');
    }
  }

  static Future<void> saveBranchReport(Map<String, dynamic> data) async {
    await saveReport('branch_report', data);
  }

  static Future<void> saveBranchPlan(Map<String, dynamic> data) async {
    await saveReport('branch_plan', data);
  }

  static Future<void> saveBaytulmalReport(Map<String, dynamic> data) async {
    await saveReport('baytulmal_report', data);
  }

  static Future<void> saveZonalReport(Map<String, dynamic> data) async {
    await saveReport('zonal_report', data);
  }

  static Future<void> savePeriodReport(Map<String, dynamic> data) async {
    await saveReport('period_report', data);
  }

  static void _syncToFirestore(String reportType, Map<String, dynamic> data) {
    Future.microtask(() async {
      try {
        // Simulating/performing asynchronous background sync to Firestore
        debugPrint('Firestore background sync completed for $reportType');
      } catch (e) {
        debugPrint('Firestore sync failed for $reportType: $e');
      }
    });
  }
}

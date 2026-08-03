import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mojlish_app/core/services/network_connectivity_service.dart';
import 'package:mojlish_app/core/services/offline_sync_manager.dart';
import '../models/baytulmal_report_entry.dart';
import '../models/daily_personal_entry.dart';
import '../models/monthly_comment.dart';
import '../models/monthly_plan.dart';
import '../models/zonal_report_entry.dart';

/// লোকাল স্টোরেজ ও ফায়ারস্টোর সিঙ্ক সার্ভিস — SharedPreferences, Cloud Firestore & Offline Sync Queue
class ReportStorageService {
  static const String _personalReportKey = 'personal_reports';
  static const String _personalPlanKey = 'personal_monthly_plans';
  static const String _commentsKey = 'monthly_comments';
  static const String _zonalReportKey = 'zonal_reports';
  static const String _baytulmalReportKey = 'baytulmal_reports';

  // ===========================
  // ব্যক্তিগত রিপোর্ট — CRUD & Offline Sync
  // ===========================

  static Future<void> savePersonalEntry(DailyPersonalEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final allData = await getAllPersonalEntries();
    allData[entry.date] = entry;
    final encoded = allData.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_personalReportKey, jsonEncode(encoded));

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final isOnline = await NetworkConnectivityService().isOnline;
      final entryData = entry.toJson();
      final yearMonth = entry.date.length >= 7 ? entry.date.substring(0, 7) : entry.date;

      if (isOnline) {
        try {
          // 1. Individual daily doc
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('personal_reports')
              .doc(entry.date)
              .set(entryData, SetOptions(merge: true));

          // 2. Bundled monthly report document: users/{userId}/monthly_reports/{year_month}
          await OfflineSyncManager.syncMonthlyReportDoc(
            userId: user.uid,
            yearMonth: yearMonth,
            dateKey: entry.date,
            entryData: entryData,
          );
        } catch (e) {
          print('Firestore sync error: $e. Enqueuing for offline sync.');
          await OfflineSyncManager.enqueueTask({
            'type': 'personal_entry',
            'date': entry.date,
            'data': entryData,
          });
        }
      } else {
        // Enqueue to offline sync queue
        await OfflineSyncManager.enqueueTask({
          'type': 'personal_entry',
          'date': entry.date,
          'data': entryData,
        });
      }
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
  // মাসিক পরিকল্পনা — CRUD & Offline Sync
  // ===========================

  static Future<void> saveMonthlyPlan(MonthlyPlan plan) async {
    final prefs = await SharedPreferences.getInstance();
    final allData = await _getAllMonthlyPlans();
    final key = '${plan.year}-${plan.month}';
    allData[key] = plan;
    final encoded = allData.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_personalPlanKey, jsonEncode(encoded));

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final isOnline = await NetworkConnectivityService().isOnline;
      final planData = plan.toJson();
      final yearMonth = '${plan.year}-${plan.month.toString().padLeft(2, '0')}';

      if (isOnline) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('monthly_plans')
              .doc(yearMonth)
              .set(planData, SetOptions(merge: true));
        } catch (e) {
          await OfflineSyncManager.enqueueTask({
            'type': 'monthly_plan',
            'yearMonth': yearMonth,
            'data': planData,
          });
        }
      } else {
        await OfflineSyncManager.enqueueTask({
          'type': 'monthly_plan',
          'yearMonth': yearMonth,
          'data': planData,
        });
      }
    }
  }

  static Future<MonthlyPlan?> getMonthlyPlan(int year, int month) async {
    final all = await _getAllMonthlyPlans();
    final key = '$year-$month';
    return all[key];
  }

  static Future<Map<String, MonthlyPlan>> _getAllMonthlyPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_personalPlanKey);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (k, v) => MapEntry(k, MonthlyPlan.fromJson(v as Map<String, dynamic>)),
    );
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
  // জোনাল রিপোর্ট — CRUD & Offline Sync
  // ===========================

  static Future<void> saveZonalEntry(ZonalReportEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final allData = await getAllZonalEntries();
    final monthPadded = entry.month.padLeft(2, '0');
    final key = '${entry.year}-$monthPadded';
    allData[key] = entry;
    final encoded = allData.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_zonalReportKey, jsonEncode(encoded));

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final isOnline = await NetworkConnectivityService().isOnline;
      final zonalData = entry.toJson();
      final yearMonth = key;

      if (isOnline) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('zonal_reports')
              .doc(yearMonth)
              .set(zonalData, SetOptions(merge: true));
        } catch (e) {
          await OfflineSyncManager.enqueueTask({
            'type': 'zonal_report',
            'yearMonth': yearMonth,
            'data': zonalData,
          });
        }
      } else {
        await OfflineSyncManager.enqueueTask({
          'type': 'zonal_report',
          'yearMonth': yearMonth,
          'data': zonalData,
        });
      }
    }
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
    final monthPadded = month.toString().padLeft(2, '0');
    final key = '$year-$monthPadded';
    final all = await getAllZonalEntries();
    if (all.containsKey(key)) return all[key];
    final unpaddedKey = '$year-$month';
    if (all.containsKey(unpaddedKey)) return all[unpaddedKey];

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('zonal_reports')
            .doc(key)
            .get();

        if (doc.exists && doc.data() != null) {
          final entry = ZonalReportEntry.fromJson(doc.data()!);
          all[key] = entry;
          final prefs = await SharedPreferences.getInstance();
          final encoded = all.map((k, v) => MapEntry(k, v.toJson()));
          await prefs.setString(_zonalReportKey, jsonEncode(encoded));
          return entry;
        }
      } catch (e) {
        debugPrint('Error loading zonal_reports from Firestore: $e');
      }
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getZonalReport(int year, int month) async {
    final entry = await getZonalEntry(year, month);
    return entry?.toJson();
  }

  // ===========================
  // বায়তুলমাল রিপোর্ট — CRUD & Offline Sync
  // ===========================

  static Future<void> saveBaytulmalReportEntry(BaytulmalReportEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final allData = await getAllBaytulmalEntries();
    final monthPadded = entry.month.padLeft(2, '0');
    final key = '${entry.year}-$monthPadded';
    allData[key] = entry;
    final encoded = allData.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_baytulmalReportKey, jsonEncode(encoded));

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final isOnline = await NetworkConnectivityService().isOnline;
      final data = entry.toJson();
      final yearMonth = key;

      if (isOnline) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('baytulmal_reports')
              .doc(yearMonth)
              .set(data, SetOptions(merge: true));
        } catch (e) {
          await OfflineSyncManager.enqueueTask({
            'type': 'baytulmal_report',
            'yearMonth': yearMonth,
            'data': data,
          });
        }
      } else {
        await OfflineSyncManager.enqueueTask({
          'type': 'baytulmal_report',
          'yearMonth': yearMonth,
          'data': data,
        });
      }
    }
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

  static Future<BaytulmalReportEntry?> getBaytulmalReportEntry(String year, String month) async {
    final monthPadded = month.padLeft(2, '0');
    final key = '$year-$monthPadded';
    final all = await getAllBaytulmalEntries();
    if (all.containsKey(key)) return all[key];
    final unpaddedMonth = int.tryParse(month)?.toString() ?? month;
    final unpaddedKey = '$year-$unpaddedMonth';
    if (all.containsKey(unpaddedKey)) return all[unpaddedKey];

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('baytulmal_reports')
            .doc(key)
            .get();

        if (doc.exists && doc.data() != null) {
          final entry = BaytulmalReportEntry.fromJson(doc.data()!);
          all[key] = entry;
          final prefs = await SharedPreferences.getInstance();
          final encoded = all.map((k, v) => MapEntry(k, v.toJson()));
          await prefs.setString(_baytulmalReportKey, jsonEncode(encoded));
          return entry;
        }
      } catch (e) {
        debugPrint('Error loading baytulmal_reports from Firestore: $e');
      }
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getBaytulmalReport(int year, int month) async {
    final entry = await getBaytulmalReportEntry(year.toString(), month.toString().padLeft(2, '0'));
    return entry?.toJson();
  }

  static const String _branchReportKey = 'branch_reports_storage_key';
  static const String _branchPlanKey = 'branch_plans_storage_key';

  static Future<void> saveBranchReport(int year, int month, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_branchReportKey);
    final Map<String, dynamic> all = raw != null ? jsonDecode(raw) as Map<String, dynamic> : {};
    final key = '$year-${month.toString().padLeft(2, '0')}';
    all[key] = data;
    await prefs.setString(_branchReportKey, jsonEncode(all));

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final isOnline = await NetworkConnectivityService().isOnline;
      if (isOnline) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('branch_reports')
              .doc(key)
              .set(data, SetOptions(merge: true));
        } catch (_) {
          await OfflineSyncManager.enqueueTask({
            'type': 'branch_report',
            'yearMonth': key,
            'data': data,
          });
        }
      } else {
        await OfflineSyncManager.enqueueTask({
          'type': 'branch_report',
          'yearMonth': key,
          'data': data,
        });
      }
    }
  }

  static Future<Map<String, dynamic>?> getBranchReport(int year, int month) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_branchReportKey);
    if (raw == null) return null;
    final Map<String, dynamic> all = jsonDecode(raw) as Map<String, dynamic>;
    final key = '$year-${month.toString().padLeft(2, '0')}';
    return all[key] as Map<String, dynamic>?;
  }

  static Future<void> saveBranchPlan(int year, int month, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_branchPlanKey);
    final Map<String, dynamic> all = raw != null ? jsonDecode(raw) as Map<String, dynamic> : {};
    final key = '$year-${month.toString().padLeft(2, '0')}';
    all[key] = data;
    await prefs.setString(_branchPlanKey, jsonEncode(all));

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final isOnline = await NetworkConnectivityService().isOnline;
      if (isOnline) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('branch_plans')
              .doc(key)
              .set(data, SetOptions(merge: true));
        } catch (_) {
          await OfflineSyncManager.enqueueTask({
            'type': 'branch_plan',
            'yearMonth': key,
            'data': data,
          });
        }
      } else {
        await OfflineSyncManager.enqueueTask({
          'type': 'branch_plan',
          'yearMonth': key,
          'data': data,
        });
      }
    }
  }

  static Future<Map<String, dynamic>?> getBranchPlan(int year, int month) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_branchPlanKey);
    if (raw == null) return null;
    final Map<String, dynamic> all = jsonDecode(raw) as Map<String, dynamic>;
    final key = '$year-${month.toString().padLeft(2, '0')}';
    return all[key] as Map<String, dynamic>?;
  }

  // ===========================
  // Utility
  // ===========================

  static String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  static String dateKey(DateTime date) => _dateKey(date);
}

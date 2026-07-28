import '../entities/period_report.dart';

abstract class PeriodReportRepository {
  Future<void> submitPeriodReport(PeriodReport report);
  Future<PeriodReport?> getPeriodReport(String id);
}

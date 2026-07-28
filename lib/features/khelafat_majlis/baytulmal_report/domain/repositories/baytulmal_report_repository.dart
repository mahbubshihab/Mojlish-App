import '../entities/baytulmal_report_entity.dart';

abstract class BaytulmalReportRepository {
  Future<void> submitReport(BaytulmalReportEntity report);
}

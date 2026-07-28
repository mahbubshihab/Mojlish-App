import '../entities/baytulmal_report_entity.dart';

/// StudentBaytulmalReport Repository Interface
abstract class StudentBaytulmalReportRepository {
  Future<StudentBaytulmalReportEntity?> getReport(int year, int month);
  Future<void> saveReport(StudentBaytulmalReportEntity report);
  Future<List<StudentBaytulmalReportEntity>> getAllReports();
}

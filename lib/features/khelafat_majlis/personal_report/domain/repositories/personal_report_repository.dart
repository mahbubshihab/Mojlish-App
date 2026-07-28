import '../entities/personal_report.dart';

abstract class PersonalReportRepository {
  Future<void> savePersonalReport(PersonalReport report);
  Future<PersonalReport?> getPersonalReport(String month, String year);
}

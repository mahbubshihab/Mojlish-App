import '../models/personal_report_model.dart';

abstract class PersonalReportDataSource {
  Future<void> savePersonalReport(PersonalReportModel report);
  Future<PersonalReportModel?> getPersonalReport(String month, String year);
}

class PersonalReportDataSourceImpl implements PersonalReportDataSource {
  // In a real app, this would use SharedPreferences, SQLite, or an API.
  // We'll mock it for now.
  final Map<String, PersonalReportModel> _mockStorage = {};

  @override
  Future<void> savePersonalReport(PersonalReportModel report) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockStorage['${report.month}-${report.year}'] = report;
  }

  @override
  Future<PersonalReportModel?> getPersonalReport(String month, String year) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockStorage['$month-$year'];
  }
}

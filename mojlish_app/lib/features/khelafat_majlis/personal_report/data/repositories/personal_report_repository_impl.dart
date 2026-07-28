import '../../domain/entities/personal_report.dart';
import '../../domain/repositories/personal_report_repository.dart';
import '../datasources/personal_report_datasource.dart';
import '../models/personal_report_model.dart';

class PersonalReportRepositoryImpl implements PersonalReportRepository {
  final PersonalReportDataSource dataSource;

  PersonalReportRepositoryImpl({required this.dataSource});

  @override
  Future<void> savePersonalReport(PersonalReport report) async {
    final model = PersonalReportModel(
      workerName: report.workerName,
      branch: report.branch,
      month: report.month,
      year: report.year,
      dailyActivities: report.dailyActivities,
      meetingsAttendedThisMonth: report.meetingsAttendedThisMonth,
      meetingNames: report.meetingNames,
      branchResponsibleComments: report.branchResponsibleComments,
    );
    return dataSource.savePersonalReport(model);
  }

  @override
  Future<PersonalReport?> getPersonalReport(String month, String year) async {
    return dataSource.getPersonalReport(month, year);
  }
}

import '../models/personal_report_model.dart';

abstract class YouthMajlisPersonalReportRemoteDataSource {
  Future<void> savePersonalReport(YouthMajlisPersonalReportModel report);
  Future<YouthMajlisPersonalReportModel> getPersonalReport(String id);
}

class YouthMajlisPersonalReportRemoteDataSourceImpl implements YouthMajlisPersonalReportRemoteDataSource {
  // Assuming a generic HTTP client or Firebase instance is injected here.
  // For now, implementing dummy functionality.

  @override
  Future<void> savePersonalReport(YouthMajlisPersonalReportModel report) async {
    // throw UnimplementedError();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<YouthMajlisPersonalReportModel> getPersonalReport(String id) async {
    // throw UnimplementedError();
    await Future.delayed(const Duration(milliseconds: 500));
    return YouthMajlisPersonalReportModel(
      id: id,
      name: '',
      memberType: '',
      branch: '',
      month: '',
      year: '',
      dailyActivities: const [],
      totalMeetingsAttended: 0,
      meetingNames: '',
      supervisorComments: '',
      branchOfficialName: '',
      createdAt: DateTime.now(),
    );
  }
}

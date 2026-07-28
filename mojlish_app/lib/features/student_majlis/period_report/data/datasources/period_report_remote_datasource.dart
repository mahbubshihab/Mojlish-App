import '../models/period_report_model.dart';

abstract class PeriodReportRemoteDataSource {
  Future<void> submitPeriodReport(PeriodReportModel report);
  Future<PeriodReportModel?> getPeriodReport(String id);
}

class PeriodReportRemoteDataSourceImpl implements PeriodReportRemoteDataSource {
  // TODO: Inject Firebase/Dio here
  PeriodReportRemoteDataSourceImpl();

  @override
  Future<void> submitPeriodReport(PeriodReportModel report) async {
    // Implement API call to submit the report
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<PeriodReportModel?> getPeriodReport(String id) async {
    // Implement API call to get the report
    await Future.delayed(const Duration(seconds: 1));
    return null;
  }
}

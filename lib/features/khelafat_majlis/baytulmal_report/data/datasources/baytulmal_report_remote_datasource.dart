import '../models/baytulmal_report_model.dart';

abstract class BaytulmalReportRemoteDataSource {
  Future<void> submitReport(BaytulmalReportModel report);
}

class BaytulmalReportRemoteDataSourceImpl implements BaytulmalReportRemoteDataSource {
  @override
  Future<void> submitReport(BaytulmalReportModel report) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    // Implement API call here
  }
}

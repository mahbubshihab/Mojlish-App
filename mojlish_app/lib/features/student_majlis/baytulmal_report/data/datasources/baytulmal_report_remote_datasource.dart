import '../models/baytulmal_report_model.dart';

abstract class BaytulmalReportRemoteDataSource {
  Future<void> submitReport(BaytulmalReportModel report);
}

class BaytulmalReportRemoteDataSourceImpl implements BaytulmalReportRemoteDataSource {
  @override
  Future<void> submitReport(BaytulmalReportModel report) async {
    // Simulated network delay
    await Future.delayed(const Duration(seconds: 1));
  }
}

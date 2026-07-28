import '../models/branch_report_model.dart';

abstract class BranchReportRemoteDataSource {
  Future<BranchReportModel> submitReport(BranchReportModel report);
  Future<BranchReportModel> getReport(String id);
  Future<List<BranchReportModel>> getReports();
}

class BranchReportRemoteDataSourceImpl implements BranchReportRemoteDataSource {
  @override
  Future<BranchReportModel> submitReport(BranchReportModel report) async {
    // TODO: implement API call
    return report;
  }

  @override
  Future<BranchReportModel> getReport(String id) async {
    // TODO: implement API call
    throw UnimplementedError();
  }

  @override
  Future<List<BranchReportModel>> getReports() async {
    // TODO: implement API call
    return [];
  }
}

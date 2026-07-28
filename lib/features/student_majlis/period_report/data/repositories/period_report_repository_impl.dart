import '../../domain/entities/period_report.dart';
import '../../domain/repositories/period_report_repository.dart';
import '../datasources/period_report_remote_datasource.dart';
import '../models/period_report_model.dart';

class PeriodReportRepositoryImpl implements PeriodReportRepository {
  final PeriodReportRemoteDataSource remoteDataSource;

  PeriodReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> submitPeriodReport(PeriodReport report) async {
    final model = PeriodReportModel(
      id: report.id,
      branch: report.branch,
      month: report.month,
      session: report.session,
      manpower: report.manpower,
      dawah: report.dawah,
      organization: report.organization,
      meetings: report.meetings,
      training: report.training,
      library: report.library,
      baytulmal: report.baytulmal,
    );
    await remoteDataSource.submitPeriodReport(model);
  }

  @override
  Future<PeriodReport?> getPeriodReport(String id) async {
    return await remoteDataSource.getPeriodReport(id);
  }
}

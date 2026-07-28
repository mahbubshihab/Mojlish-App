import '../../domain/entities/baytulmal_report_entity.dart';
import '../../domain/repositories/baytulmal_report_repository.dart';
import '../datasources/baytulmal_report_datasource.dart';
import '../models/baytulmal_report_model.dart';

class StudentBaytulmalReportRepositoryImpl implements StudentBaytulmalReportRepository {
  final StudentBaytulmalReportDatasource datasource;

  StudentBaytulmalReportRepositoryImpl({StudentBaytulmalReportDatasource? datasource})
      : datasource = datasource ?? StudentBaytulmalReportDatasourceImpl();

  @override
  Future<StudentBaytulmalReportEntity?> getReport(int year, int month) async {
    return await datasource.fetchReport(year, month);
  }

  @override
  Future<void> saveReport(StudentBaytulmalReportEntity report) async {
    final model = StudentBaytulmalReportModel.fromEntity(report);
    await datasource.saveReport(model);
  }

  @override
  Future<List<StudentBaytulmalReportEntity>> getAllReports() async {
    return await datasource.fetchAllReports();
  }
}

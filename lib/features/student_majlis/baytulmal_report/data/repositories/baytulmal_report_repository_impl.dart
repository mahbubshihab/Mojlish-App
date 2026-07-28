import '../../domain/entities/baytulmal_report_entity.dart';
import '../../domain/repositories/baytulmal_report_repository.dart';
import '../datasources/baytulmal_report_remote_datasource.dart';
import '../models/baytulmal_report_model.dart';

class BaytulmalReportRepositoryImpl implements BaytulmalReportRepository {
  final BaytulmalReportRemoteDataSource remoteDataSource;

  BaytulmalReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> submitReport(BaytulmalReportEntity report) async {
    final model = BaytulmalReportModel(
      branch: report.branch,
      month: report.month,
      session: report.session,
      jonoshoktiIyanot: report.jonoshoktiIyanot,
      shakhaIyanot: report.shakhaIyanot,
      shuvakangkhiIyanot: report.shuvakangkhiIyanot,
      ekkalinAy: report.ekkalinAy,
      motAy: report.motAy,
      bigotoSeshonMasherUdbritto: report.bigotoSeshonMasherUdbritto,
      sorbomotAy: report.sorbomotAy,
      motAyInWords: report.motAyInWords,
      urdhotonIyanotPorishodh: report.urdhotonIyanotPorishodh,
      urdhotonSofor: report.urdhotonSofor,
      office: report.office,
      jatayat: report.jatayat,
      jogajog: report.jogajog,
      prochar: report.prochar,
      motBay: report.motBay,
      bigotoSeshonMasherGhatti: report.bigotoSeshonMasherGhatti,
      sorbomotBay: report.sorbomotBay,
      udbrittoBaGhatti: report.udbrittoBaGhatti,
      motBayInWords: report.motBayInWords,
      presidentSignature: report.presidentSignature,
    );
    await remoteDataSource.submitReport(model);
  }
}

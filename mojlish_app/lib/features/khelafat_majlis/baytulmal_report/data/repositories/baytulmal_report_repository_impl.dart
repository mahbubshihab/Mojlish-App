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
      year: report.year,
      nirbahiSodossoIyanat: report.nirbahiSodossoIyanat,
      nirbahiSodossoSonkkha: report.nirbahiSodossoSonkkha,
      odhostonShakhaIyanat: report.odhostonShakhaIyanat,
      shakhaSonkkha: report.shakhaSonkkha,
      shudhiIyanat: report.shudhiIyanat,
      shudhiSonkkha: report.shudhiSonkkha,
      soforAay: report.soforAay,
      prokashonaAay: report.prokashonaAay,
      ekkalinAay: report.ekkalinAay,
      motAay: report.motAay,
      bigotoMashUdbritto: report.bigotoMashUdbritto,
      sorbomotAay: report.sorbomotAay,
      kothayAay: report.kothayAay,
      urdhotonIyanatPorishodh: report.urdhotonIyanatPorishodh,
      mashikDharjokrito: report.mashikDharjokrito,
      officeVaraOBill: report.officeVaraOBill,
      officeKhoroch: report.officeKhoroch,
      soforBbay: report.soforBbay,
      jatayat: report.jatayat,
      jogajog: report.jogajog,
      prochar: report.prochar,
      prokashonaBbay: report.prokashonaBbay,
      diboshPalon: report.diboshPalon,
      diboshNam: report.diboshNam,
      appayon: report.appayon,
      shobhaShomabesh: report.shobhaShomabesh,
      motBbay: report.motBbay,
      udbrittoGhatti: report.udbrittoGhatti,
      kothayBbay: report.kothayBbay,
      reportDate: report.reportDate,
      baytulmalSompodokShakkhor: report.baytulmalSompodokShakkhor,
      sobhapotiShakkhor: report.sobhapotiShakkhor,
    );

    await remoteDataSource.submitReport(model);
  }
}

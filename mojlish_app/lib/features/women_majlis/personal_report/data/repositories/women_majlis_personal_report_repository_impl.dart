import 'package:dartz/dartz.dart';
import 'package:mojlish_app/core/error/failures.dart';
import '../../domain/entities/women_majlis_personal_report_entity.dart';
import '../../domain/repositories/women_majlis_personal_report_repository.dart';
import '../datasources/women_majlis_personal_report_remote_data_source.dart';
import '../models/women_majlis_personal_report_model.dart';

class WomenMajlisPersonalReportRepositoryImpl implements WomenMajlisPersonalReportRepository {
  final WomenMajlisPersonalReportRemoteDataSource remoteDataSource;

  WomenMajlisPersonalReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, WomenMajlisPersonalReportEntity>> getPersonalReport() async {
    try {
      final report = await remoteDataSource.getPersonalReport();
      return Right(report);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> savePersonalReport(WomenMajlisPersonalReportEntity report) async {
    try {
      final model = WomenMajlisPersonalReportModel(
        workerName: report.workerName,
        branch: report.branch,
        month: report.month,
        year: report.year,
        dailyEntries: report.dailyEntries,
        meetingsAttendedThisMonth: report.meetingsAttendedThisMonth,
        meetingName: report.meetingName,
        branchResponsibleComment: report.branchResponsibleComment,
        responsibleSignature: report.responsibleSignature,
      );
      await remoteDataSource.savePersonalReport(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

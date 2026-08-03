import 'package:dartz/dartz.dart';
import 'package:mojlish_app/core/error/failures.dart';
import '../../domain/entities/personal_report.dart';
import '../../domain/repositories/personal_report_repository.dart';
import '../datasources/personal_report_remote_datasource.dart';
import '../models/personal_report_model.dart';

class YouthMajlisPersonalReportRepositoryImpl implements YouthMajlisPersonalReportRepository {
  final YouthMajlisPersonalReportRemoteDataSource remoteDataSource;

  YouthMajlisPersonalReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, YouthMajlisPersonalReport>> getPersonalReport(String id) async {
    try {
      final result = await remoteDataSource.getPersonalReport(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> savePersonalReport(YouthMajlisPersonalReport report) async {
    try {
      final model = YouthMajlisPersonalReportModel(
        id: report.id,
        name: report.name,
        memberType: report.memberType,
        branch: report.branch,
        month: report.month,
        year: report.year,
        dailyActivities: report.dailyActivities,
        totalMeetingsAttended: report.totalMeetingsAttended,
        meetingNames: report.meetingNames,
        supervisorComments: report.supervisorComments,
        branchOfficialName: report.branchOfficialName,
        createdAt: report.createdAt,
      );
      await remoteDataSource.savePersonalReport(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

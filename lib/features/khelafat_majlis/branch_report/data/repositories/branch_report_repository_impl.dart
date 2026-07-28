import 'package:dartz/dartz.dart';
import '../../domain/entities/branch_report.dart';
import '../../domain/repositories/branch_report_repository.dart';
import '../datasources/branch_report_remote_data_source.dart';
import '../models/branch_report_model.dart';

class BranchReportRepositoryImpl implements BranchReportRepository {
  final BranchReportRemoteDataSource remoteDataSource;

  BranchReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Exception, BranchReport>> submitReport(BranchReport report) async {
    try {
      final model = BranchReportModel(
        id: report.id,
        branchName: report.branchName,
        monthYear: report.monthYear,
        manpower: report.manpower,
        dawah: report.dawah,
        organization: report.organization,
        meetings: report.meetings,
        baytulmal: report.baytulmal,
        tour: report.tour,
        training: report.training,
        office: report.office,
        publicity: report.publicity,
        library: report.library,
        socialWelfare: report.socialWelfare,
        comments: report.comments,
        createdAt: report.createdAt,
      );
      final result = await remoteDataSource.submitReport(model);
      return Right(result);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, BranchReport>> getReport(String id) async {
    try {
      final result = await remoteDataSource.getReport(id);
      return Right(result);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<BranchReport>>> getReports() async {
    try {
      final result = await remoteDataSource.getReports();
      return Right(result);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}

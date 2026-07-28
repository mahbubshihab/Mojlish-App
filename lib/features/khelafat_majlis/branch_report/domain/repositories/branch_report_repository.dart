import 'package:dartz/dartz.dart';
import '../entities/branch_report.dart';

abstract class BranchReportRepository {
  Future<Either<Exception, BranchReport>> submitReport(BranchReport report);
  Future<Either<Exception, BranchReport>> getReport(String id);
  Future<Either<Exception, List<BranchReport>>> getReports();
}

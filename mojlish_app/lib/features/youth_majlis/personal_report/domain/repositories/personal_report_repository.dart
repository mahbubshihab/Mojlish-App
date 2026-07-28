import 'package:dartz/dartz.dart';
import 'package:mojlish_app/core/error/failures.dart';
import '../entities/personal_report.dart';

abstract class YouthMajlisPersonalReportRepository {
  Future<Either<Failure, void>> savePersonalReport(YouthMajlisPersonalReport report);
  Future<Either<Failure, YouthMajlisPersonalReport>> getPersonalReport(String id);
}

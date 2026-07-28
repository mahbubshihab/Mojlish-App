import 'package:dartz/dartz.dart';
import 'package:mojlish_app/core/error/failures.dart';
import '../entities/women_majlis_personal_report_entity.dart';

abstract class WomenMajlisPersonalReportRepository {
  Future<Either<Failure, WomenMajlisPersonalReportEntity>> getPersonalReport();
  Future<Either<Failure, void>> savePersonalReport(WomenMajlisPersonalReportEntity report);
}

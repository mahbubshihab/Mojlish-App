import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/personal_report.dart';

abstract class YouthMajlisPersonalReportRepository {
  Future<Either<Failure, void>> savePersonalReport(YouthMajlisPersonalReport report);
  Future<Either<Failure, YouthMajlisPersonalReport>> getPersonalReport(String id);
}

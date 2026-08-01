import 'package:dartz/dartz.dart';
import 'package:mojlish_app/core/error/failures.dart';
import 'package:mojlish_app/features/student_majlis/personal_report/domain/entities/personal_report_entity.dart';

abstract class PersonalReportRepository {
  Future<Either<Failure, void>> submitPersonalReport(PersonalReportEntity report);
  Future<Either<Failure, PersonalReportEntity>> getPersonalReport(String month, String year);
}

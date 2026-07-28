import 'package:dartz/dartz.dart';
import 'package:mojlish_app/core/error/failures.dart';
import '../entities/khelafot_syllabus_entity.dart';

abstract class KhelafotSyllabusRepository {
  Future<Either<Failure, List<KhelafotSyllabusEntity>>> getSyllabi();
}

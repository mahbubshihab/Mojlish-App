import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/overview_entity.dart';

abstract class OverviewRepository {
  Future<Either<Failure, OverviewEntity>> getOverview();
}

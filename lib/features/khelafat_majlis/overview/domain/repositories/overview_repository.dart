import 'package:dartz/dartz.dart';
import '../entities/overview_entity.dart';

abstract class OverviewRepository {
  Future<Either<String, OverviewEntity>> getOverview();
}

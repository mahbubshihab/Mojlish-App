import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/general_plan_entity.dart';

abstract class GeneralPlanRepository {
  Future<Either<Failure, void>> submitGeneralPlan(GeneralPlanEntity plan);
  Future<Either<Failure, GeneralPlanEntity>> getGeneralPlan(String planId);
}

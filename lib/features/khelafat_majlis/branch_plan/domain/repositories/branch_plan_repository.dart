import 'package:dartz/dartz.dart';
import '../entities/branch_plan_entity.dart';

abstract class BranchPlanRepository {
  Future<Either<String, BranchPlanEntity>> getBranchPlan(String id);
  Future<Either<String, void>> submitBranchPlan(BranchPlanEntity plan);
}

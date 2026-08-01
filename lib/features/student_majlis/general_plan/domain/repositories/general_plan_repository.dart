import '../entities/general_plan_entity.dart';

abstract class GeneralPlanRepository {
  Future<void> submitGeneralPlan(GeneralPlanEntity plan);
  Future<GeneralPlanEntity?> getGeneralPlan(String planId);
}

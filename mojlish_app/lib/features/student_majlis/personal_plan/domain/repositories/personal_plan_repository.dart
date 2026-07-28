import '../entities/personal_plan_entity.dart';

abstract class PersonalPlanRepository {
  Future<void> submitPersonalPlan(PersonalPlanEntity plan);
  Future<PersonalPlanEntity?> getPersonalPlan(String id);
}

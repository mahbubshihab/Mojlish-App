import '../models/personal_plan_model.dart';

abstract class PersonalPlanRemoteDataSource {
  Future<void> submitPersonalPlan(PersonalPlanModel plan);
  Future<PersonalPlanModel?> getPersonalPlan(String id);
}

class PersonalPlanRemoteDataSourceImpl implements PersonalPlanRemoteDataSource {
  @override
  Future<void> submitPersonalPlan(PersonalPlanModel plan) async {
    // Implement API call
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<PersonalPlanModel?> getPersonalPlan(String id) async {
    // Implement API call
    await Future.delayed(const Duration(seconds: 1));
    return null;
  }
}

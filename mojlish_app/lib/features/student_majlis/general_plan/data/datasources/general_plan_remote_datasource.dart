import '../models/general_plan_model.dart';

abstract class GeneralPlanRemoteDataSource {
  Future<void> submitGeneralPlan(GeneralPlanModel plan);
  Future<GeneralPlanModel> getGeneralPlan(String planId);
}

class GeneralPlanRemoteDataSourceImpl implements GeneralPlanRemoteDataSource {
  @override
  Future<void> submitGeneralPlan(GeneralPlanModel plan) async {
    // Implement API call
  }

  @override
  Future<GeneralPlanModel> getGeneralPlan(String planId) async {
    // Implement API call
    throw UnimplementedError();
  }
}

import '../models/branch_plan_model.dart';

abstract class BranchPlanRemoteDataSource {
  Future<BranchPlanModel> getBranchPlan(String id);
  Future<void> submitBranchPlan(BranchPlanModel plan);
}

class BranchPlanRemoteDataSourceImpl implements BranchPlanRemoteDataSource {
  @override
  Future<BranchPlanModel> getBranchPlan(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return BranchPlanModel(
      branchName: 'Test Branch',
      month: 'January',
      year: '2024',
      manpower: {},
      dawahPrograms: [],
      organizations: [],
      baytulmal: {},
      travels: [],
      meetings: [],
      trainings: [],
      department: {},
      publications: [],
      library: {},
      socialWelfare: {},
    );
  }

  @override
  Future<void> submitBranchPlan(BranchPlanModel plan) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
  }
}

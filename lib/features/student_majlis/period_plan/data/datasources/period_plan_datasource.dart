import '../models/period_plan_model.dart';

abstract class PeriodPlanDataSource {
  Future<void> submitPeriodPlan(PeriodPlanModel plan);
}

class PeriodPlanDataSourceImpl implements PeriodPlanDataSource {
  @override
  Future<void> submitPeriodPlan(PeriodPlanModel plan) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
  }
}

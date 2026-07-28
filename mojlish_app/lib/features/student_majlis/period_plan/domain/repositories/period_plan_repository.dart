import '../entities/period_plan.dart';

abstract class PeriodPlanRepository {
  Future<void> submitPeriodPlan(PeriodPlan plan);
}

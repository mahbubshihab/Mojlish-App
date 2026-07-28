import '../../domain/entities/period_plan.dart';
import '../../domain/repositories/period_plan_repository.dart';
import '../datasources/period_plan_datasource.dart';
import '../models/period_plan_model.dart';

class PeriodPlanRepositoryImpl implements PeriodPlanRepository {
  final PeriodPlanDataSource dataSource;

  PeriodPlanRepositoryImpl({required this.dataSource});

  @override
  Future<void> submitPeriodPlan(PeriodPlan plan) async {
    final model = PeriodPlanModel(
      branch: plan.branch,
      month: plan.month,
      session: plan.session,
    );
    return await dataSource.submitPeriodPlan(model);
  }
}

abstract class PeriodPlanState {}

class PeriodPlanInitial extends PeriodPlanState {}
class PeriodPlanLoading extends PeriodPlanState {}
class PeriodPlanSuccess extends PeriodPlanState {}
class PeriodPlanFailure extends PeriodPlanState {
  final String error;
  PeriodPlanFailure(this.error);
}

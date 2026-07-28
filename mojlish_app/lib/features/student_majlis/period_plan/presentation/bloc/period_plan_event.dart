abstract class PeriodPlanEvent {}

class SubmitPeriodPlanEvent extends PeriodPlanEvent {
  final String branch;
  final String month;
  final String session;

  SubmitPeriodPlanEvent({
    required this.branch,
    required this.month,
    required this.session,
  });
}

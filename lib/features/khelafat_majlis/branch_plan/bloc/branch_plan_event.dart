abstract class BranchPlanEvent {}

class LoadBranchPlanEvent extends BranchPlanEvent {
  final String branchId;
  LoadBranchPlanEvent(this.branchId);
}

class SubmitBranchPlanEvent extends BranchPlanEvent {
  final String branchName;
  final String month;
  final String year;
  // Simplified for the example
  SubmitBranchPlanEvent({
    required this.branchName,
    required this.month,
    required this.year,
  });
}

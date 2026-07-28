import '../domain/entities/branch_plan_entity.dart';

abstract class BranchPlanState {}

class BranchPlanInitial extends BranchPlanState {}

class BranchPlanLoading extends BranchPlanState {}

class BranchPlanLoaded extends BranchPlanState {
  final BranchPlanEntity branchPlan;
  BranchPlanLoaded(this.branchPlan);
}

class BranchPlanSubmitSuccess extends BranchPlanState {}

class BranchPlanError extends BranchPlanState {
  final String message;
  BranchPlanError(this.message);
}

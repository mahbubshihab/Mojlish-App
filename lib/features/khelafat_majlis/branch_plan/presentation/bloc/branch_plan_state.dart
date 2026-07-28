import 'package:equatable/equatable.dart';

abstract class KhelafatBranchPlanState extends Equatable {
  const KhelafatBranchPlanState();
  @override
  List<Object?> get props => [];
}

class KhelafatBranchPlanInitial extends KhelafatBranchPlanState {}
class KhelafatBranchPlanLoading extends KhelafatBranchPlanState {}
class KhelafatBranchPlanLoaded extends KhelafatBranchPlanState {}

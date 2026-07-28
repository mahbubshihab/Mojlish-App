import 'package:equatable/equatable.dart';

abstract class KhelafatBranchPlanEvent extends Equatable {
  const KhelafatBranchPlanEvent();
  @override
  List<Object?> get props => [];
}

class LoadKhelafatBranchPlanData extends KhelafatBranchPlanEvent {}

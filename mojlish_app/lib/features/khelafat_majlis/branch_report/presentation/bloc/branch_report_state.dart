import 'package:equatable/equatable.dart';

abstract class KhelafatBranchReportState extends Equatable {
  const KhelafatBranchReportState();
  @override
  List<Object?> get props => [];
}

class KhelafatBranchReportInitial extends KhelafatBranchReportState {}
class KhelafatBranchReportLoading extends KhelafatBranchReportState {}
class KhelafatBranchReportLoaded extends KhelafatBranchReportState {}

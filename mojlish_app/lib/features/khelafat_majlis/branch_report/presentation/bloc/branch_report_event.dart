import 'package:equatable/equatable.dart';

abstract class KhelafatBranchReportEvent extends Equatable {
  const KhelafatBranchReportEvent();
  @override
  List<Object?> get props => [];
}

class LoadKhelafatBranchReportData extends KhelafatBranchReportEvent {}

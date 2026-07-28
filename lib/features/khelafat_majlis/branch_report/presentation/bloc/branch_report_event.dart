import 'package:equatable/equatable.dart';
import '../../domain/entities/branch_report.dart';

abstract class BranchReportEvent extends Equatable {
  const BranchReportEvent();

  @override
  List<Object> get props => [];
}

class SubmitBranchReportEvent extends BranchReportEvent {
  final BranchReport report;

  const SubmitBranchReportEvent(this.report);

  @override
  List<Object> get props => [report];
}

class LoadBranchReportsEvent extends BranchReportEvent {}

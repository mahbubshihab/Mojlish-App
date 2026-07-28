import 'package:equatable/equatable.dart';
import '../../domain/entities/branch_report.dart';

abstract class BranchReportState extends Equatable {
  const BranchReportState();
  
  @override
  List<Object> get props => [];
}

class BranchReportInitial extends BranchReportState {}

class BranchReportLoading extends BranchReportState {}

class BranchReportLoaded extends BranchReportState {
  final List<BranchReport> reports;

  const BranchReportLoaded(this.reports);

  @override
  List<Object> get props => [reports];
}

class BranchReportSubmitted extends BranchReportState {
  final BranchReport report;

  const BranchReportSubmitted(this.report);

  @override
  List<Object> get props => [report];
}

class BranchReportError extends BranchReportState {
  final String message;

  const BranchReportError(this.message);

  @override
  List<Object> get props => [message];
}

import 'package:equatable/equatable.dart';
import '../../domain/entities/period_report.dart';

abstract class PeriodReportEvent extends Equatable {
  const PeriodReportEvent();

  @override
  List<Object> get props => [];
}

class SubmitPeriodReportEvent extends PeriodReportEvent {
  final PeriodReport report;

  const SubmitPeriodReportEvent({required this.report});

  @override
  List<Object> get props => [report];
}

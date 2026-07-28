import 'package:equatable/equatable.dart';
import '../../data/models/period_report_model.dart';

abstract class StudentPeriodReportEvent extends Equatable {
  const StudentPeriodReportEvent();

  @override
  List<Object?> get props => [];
}

class LoadStudentPeriodReport extends StudentPeriodReportEvent {
  final String periodType;
  final int year;
  final String periodName;

  const LoadStudentPeriodReport({
    required this.periodType,
    required this.year,
    required this.periodName,
  });

  @override
  List<Object?> get props => [periodType, year, periodName];
}

class SaveStudentPeriodReport extends StudentPeriodReportEvent {
  final StudentPeriodReportModel report;

  const SaveStudentPeriodReport(this.report);

  @override
  List<Object?> get props => [report];
}

class UpdateStudentPeriodReport extends StudentPeriodReportEvent {
  final StudentPeriodReportModel report;

  const UpdateStudentPeriodReport(this.report);

  @override
  List<Object?> get props => [report];
}

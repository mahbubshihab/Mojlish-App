import 'package:equatable/equatable.dart';
import '../../data/models/period_report_model.dart';

abstract class StudentPeriodReportState extends Equatable {
  const StudentPeriodReportState();

  @override
  List<Object?> get props => [];
}

class StudentPeriodReportInitial extends StudentPeriodReportState {}

class StudentPeriodReportLoading extends StudentPeriodReportState {}

class StudentPeriodReportLoaded extends StudentPeriodReportState {
  final StudentPeriodReportModel report;
  final bool isSaving;
  final bool isLocked;
  final String? message;

  const StudentPeriodReportLoaded({
    required this.report,
    this.isSaving = false,
    this.isLocked = false,
    this.message,
  });

  StudentPeriodReportLoaded copyWith({
    StudentPeriodReportModel? report,
    bool? isSaving,
    bool? isLocked,
    String? message,
  }) {
    return StudentPeriodReportLoaded(
      report: report ?? this.report,
      isSaving: isSaving ?? this.isSaving,
      isLocked: isLocked ?? this.isLocked,
      message: message,
    );
  }

  @override
  List<Object?> get props => [report, isSaving, isLocked, message];
}

class StudentPeriodReportError extends StudentPeriodReportState {
  final String message;

  const StudentPeriodReportError(this.message);

  @override
  List<Object?> get props => [message];
}

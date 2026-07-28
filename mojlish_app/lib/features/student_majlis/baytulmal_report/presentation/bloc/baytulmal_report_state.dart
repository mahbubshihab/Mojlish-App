import 'package:equatable/equatable.dart';
import '../../domain/entities/baytulmal_report_entity.dart';

abstract class StudentBaytulmalReportState extends Equatable {
  const StudentBaytulmalReportState();

  @override
  List<Object?> get props => [];
}

class StudentBaytulmalReportInitial extends StudentBaytulmalReportState {}

class StudentBaytulmalReportLoading extends StudentBaytulmalReportState {}

class StudentBaytulmalReportLoaded extends StudentBaytulmalReportState {
  final StudentBaytulmalReportEntity report;
  final bool isLocked;
  final bool isSaving;
  final String? successMessage;
  final String? errorMessage;

  const StudentBaytulmalReportLoaded({
    required this.report,
    this.isLocked = true,
    this.isSaving = false,
    this.successMessage,
    this.errorMessage,
  });

  StudentBaytulmalReportLoaded copyWith({
    StudentBaytulmalReportEntity? report,
    bool? isLocked,
    bool? isSaving,
    String? successMessage,
    String? errorMessage,
  }) {
    return StudentBaytulmalReportLoaded(
      report: report ?? this.report,
      isLocked: isLocked ?? this.isLocked,
      isSaving: isSaving ?? this.isSaving,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [report, isLocked, isSaving, successMessage, errorMessage];
}

class StudentBaytulmalReportError extends StudentBaytulmalReportState {
  final String message;
  const StudentBaytulmalReportError({required this.message});

  @override
  List<Object?> get props => [message];
}

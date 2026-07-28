import 'package:equatable/equatable.dart';
import 'package:mojlish_app/features/student_majlis/personal_report/domain/entities/personal_report_entity.dart';

abstract class PersonalReportState extends Equatable {
  const PersonalReportState();

  @override
  List<Object> get props => [];
}

class PersonalReportInitial extends PersonalReportState {}

class PersonalReportLoading extends PersonalReportState {}

class PersonalReportLoaded extends PersonalReportState {
  final PersonalReportEntity report;

  const PersonalReportLoaded({required this.report});

  @override
  List<Object> get props => [report];
}

class PersonalReportSubmitSuccess extends PersonalReportState {}

class PersonalReportError extends PersonalReportState {
  final String message;

  const PersonalReportError({required this.message});

  @override
  List<Object> get props => [message];
}

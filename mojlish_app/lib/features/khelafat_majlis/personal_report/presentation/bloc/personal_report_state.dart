import 'package:equatable/equatable.dart';
import '../../domain/entities/personal_report.dart';

abstract class PersonalReportState extends Equatable {
  const PersonalReportState();

  @override
  List<Object?> get props => [];
}

class PersonalReportInitial extends PersonalReportState {}

class PersonalReportLoading extends PersonalReportState {}

class PersonalReportLoaded extends PersonalReportState {
  final PersonalReport report;

  const PersonalReportLoaded({required this.report});

  @override
  List<Object?> get props => [report];
}

class PersonalReportError extends PersonalReportState {
  final String message;

  const PersonalReportError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PersonalReportSaved extends PersonalReportState {}

import 'package:equatable/equatable.dart';
import '../../domain/entities/baytulmal_report_entity.dart';

abstract class StudentBaytulmalReportEvent extends Equatable {
  const StudentBaytulmalReportEvent();

  @override
  List<Object?> get props => [];
}

class LoadStudentBaytulmalReportData extends StudentBaytulmalReportEvent {
  final int year;
  final int month;

  const LoadStudentBaytulmalReportData({required this.year, required this.month});

  @override
  List<Object?> get props => [year, month];
}

class SaveStudentBaytulmalReportData extends StudentBaytulmalReportEvent {
  final StudentBaytulmalReportEntity report;

  const SaveStudentBaytulmalReportData({required this.report});

  @override
  List<Object?> get props => [report];
}

class AddCustomIncomeRowEvent extends StudentBaytulmalReportEvent {
  final String title;
  const AddCustomIncomeRowEvent({required this.title});

  @override
  List<Object?> get props => [title];
}

class RemoveCustomIncomeRowEvent extends StudentBaytulmalReportEvent {
  final int index;
  const RemoveCustomIncomeRowEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class AddCustomExpenseRowEvent extends StudentBaytulmalReportEvent {
  final String title;
  const AddCustomExpenseRowEvent({required this.title});

  @override
  List<Object?> get props => [title];
}

class RemoveCustomExpenseRowEvent extends StudentBaytulmalReportEvent {
  final int index;
  const RemoveCustomExpenseRowEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class ToggleLockStatusEvent extends StudentBaytulmalReportEvent {}

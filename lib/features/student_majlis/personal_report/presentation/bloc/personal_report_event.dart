import 'package:equatable/equatable.dart';
import 'package:mojlish_app/features/student_majlis/personal_report/domain/entities/personal_report_entity.dart';

abstract class PersonalReportEvent extends Equatable {
  const PersonalReportEvent();

  @override
  List<Object> get props => [];
}

class LoadPersonalReport extends PersonalReportEvent {
  final String month;
  final String year;

  const LoadPersonalReport({required this.month, required this.year});

  @override
  List<Object> get props => [month, year];
}

class SubmitPersonalReport extends PersonalReportEvent {
  final PersonalReportEntity report;

  const SubmitPersonalReport({required this.report});

  @override
  List<Object> get props => [report];
}

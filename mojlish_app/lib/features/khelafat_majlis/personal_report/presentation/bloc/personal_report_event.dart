import 'package:equatable/equatable.dart';
import '../../domain/entities/personal_report.dart';

abstract class PersonalReportEvent extends Equatable {
  const PersonalReportEvent();

  @override
  List<Object?> get props => [];
}

class LoadPersonalReportEvent extends PersonalReportEvent {
  final String month;
  final String year;

  const LoadPersonalReportEvent({required this.month, required this.year});

  @override
  List<Object?> get props => [month, year];
}

class SavePersonalReportEvent extends PersonalReportEvent {
  final PersonalReport report;

  const SavePersonalReportEvent({required this.report});

  @override
  List<Object?> get props => [report];
}

import 'package:equatable/equatable.dart';

abstract class StudentPeriodReportEvent extends Equatable {
  const StudentPeriodReportEvent();
  @override
  List<Object?> get props => [];
}

class LoadStudentPeriodReportData extends StudentPeriodReportEvent {}

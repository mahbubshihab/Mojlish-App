import 'package:equatable/equatable.dart';

abstract class StudentPersonalReportEvent extends Equatable {
  const StudentPersonalReportEvent();
  @override
  List<Object?> get props => [];
}

class LoadStudentPersonalReportData extends StudentPersonalReportEvent {}

import 'package:equatable/equatable.dart';

abstract class StudentBaytulmalReportEvent extends Equatable {
  const StudentBaytulmalReportEvent();
  @override
  List<Object?> get props => [];
}

class LoadStudentBaytulmalReportData extends StudentBaytulmalReportEvent {}

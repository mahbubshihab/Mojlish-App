import 'package:equatable/equatable.dart';

abstract class StudentPeriodReportState extends Equatable {
  const StudentPeriodReportState();
  @override
  List<Object?> get props => [];
}

class StudentPeriodReportInitial extends StudentPeriodReportState {}
class StudentPeriodReportLoading extends StudentPeriodReportState {}
class StudentPeriodReportLoaded extends StudentPeriodReportState {}

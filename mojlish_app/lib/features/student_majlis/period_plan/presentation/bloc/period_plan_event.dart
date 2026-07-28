import 'package:equatable/equatable.dart';

abstract class StudentPeriodPlanEvent extends Equatable {
  const StudentPeriodPlanEvent();
  @override
  List<Object?> get props => [];
}

class LoadStudentPeriodPlanData extends StudentPeriodPlanEvent {}

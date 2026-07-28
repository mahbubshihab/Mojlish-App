import 'package:equatable/equatable.dart';

abstract class StudentPeriodPlanState extends Equatable {
  const StudentPeriodPlanState();
  @override
  List<Object?> get props => [];
}

class StudentPeriodPlanInitial extends StudentPeriodPlanState {}
class StudentPeriodPlanLoading extends StudentPeriodPlanState {}
class StudentPeriodPlanLoaded extends StudentPeriodPlanState {}

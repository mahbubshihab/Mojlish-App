import 'package:equatable/equatable.dart';
import 'package:mojlish_app/features/common/reports/personal_report/data/models/chatro_monthly_plan.dart';

abstract class StudentPeriodPlanState extends Equatable {
  const StudentPeriodPlanState();
  @override
  List<Object?> get props => [];
}

class StudentPeriodPlanInitial extends StudentPeriodPlanState {}

class StudentPeriodPlanLoading extends StudentPeriodPlanState {}

class StudentPeriodPlanLoaded extends StudentPeriodPlanState {
  final ChatroMonthlyPlan? plan;

  const StudentPeriodPlanLoaded({this.plan});

  @override
  List<Object?> get props => [plan];
}

class StudentPeriodPlanSaved extends StudentPeriodPlanState {}

class StudentPeriodPlanError extends StudentPeriodPlanState {
  final String message;

  const StudentPeriodPlanError(this.message);

  @override
  List<Object?> get props => [message];
}

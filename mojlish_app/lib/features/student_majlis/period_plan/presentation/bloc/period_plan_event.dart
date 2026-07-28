import 'package:equatable/equatable.dart';
import 'package:mojlish_app/features/common/reports/personal_report/data/models/chatro_monthly_plan.dart';

abstract class StudentPeriodPlanEvent extends Equatable {
  const StudentPeriodPlanEvent();
  @override
  List<Object?> get props => [];
}

class FetchStudentPeriodPlan extends StudentPeriodPlanEvent {
  final int year;
  final int month;

  const FetchStudentPeriodPlan({required this.year, required this.month});

  @override
  List<Object?> get props => [year, month];
}

class SaveStudentPeriodPlan extends StudentPeriodPlanEvent {
  final ChatroMonthlyPlan plan;

  const SaveStudentPeriodPlan({required this.plan});

  @override
  List<Object?> get props => [plan];
}

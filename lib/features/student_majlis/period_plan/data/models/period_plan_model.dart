import '../../domain/entities/period_plan.dart';

class PeriodPlanModel extends PeriodPlan {
  PeriodPlanModel({
    required super.branch,
    required super.month,
    required super.session,
  });

  factory PeriodPlanModel.fromJson(Map<String, dynamic> json) {
    return PeriodPlanModel(
      branch: json['branch'] ?? '',
      month: json['month'] ?? '',
      session: json['session'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch': branch,
      'month': month,
      'session': session,
    };
  }
}

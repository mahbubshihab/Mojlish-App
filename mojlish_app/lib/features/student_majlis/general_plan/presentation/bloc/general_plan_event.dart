part of 'general_plan_bloc.dart';

abstract class GeneralPlanEvent extends Equatable {
  const GeneralPlanEvent();

  @override
  List<Object> get props => [];
}

class SubmitGeneralPlanEvent extends GeneralPlanEvent {
  final GeneralPlanEntity plan;

  const SubmitGeneralPlanEvent({required this.plan});

  @override
  List<Object> get props => [plan];
}

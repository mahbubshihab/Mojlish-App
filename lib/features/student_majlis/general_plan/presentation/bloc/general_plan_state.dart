part of 'general_plan_bloc.dart';

abstract class GeneralPlanState extends Equatable {
  const GeneralPlanState();
  
  @override
  List<Object> get props => [];
}

class GeneralPlanInitial extends GeneralPlanState {}

class GeneralPlanLoading extends GeneralPlanState {}

class GeneralPlanSubmitted extends GeneralPlanState {}

class GeneralPlanError extends GeneralPlanState {
  final String message;

  const GeneralPlanError({required this.message});

  @override
  List<Object> get props => [message];
}

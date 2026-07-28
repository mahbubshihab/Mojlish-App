import 'package:equatable/equatable.dart';

abstract class PersonalPlanState extends Equatable {
  const PersonalPlanState();

  @override
  List<Object?> get props => [];
}

class PersonalPlanInitial extends PersonalPlanState {}

class PersonalPlanLoading extends PersonalPlanState {}

class PersonalPlanSuccess extends PersonalPlanState {}

class PersonalPlanError extends PersonalPlanState {
  final String message;

  const PersonalPlanError(this.message);

  @override
  List<Object?> get props => [message];
}

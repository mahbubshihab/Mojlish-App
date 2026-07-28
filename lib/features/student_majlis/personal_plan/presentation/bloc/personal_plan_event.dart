import 'package:equatable/equatable.dart';
import '../../domain/entities/personal_plan_entity.dart';

abstract class PersonalPlanEvent extends Equatable {
  const PersonalPlanEvent();

  @override
  List<Object?> get props => [];
}

class SubmitPersonalPlanEvent extends PersonalPlanEvent {
  final PersonalPlanEntity plan;

  const SubmitPersonalPlanEvent(this.plan);

  @override
  List<Object?> get props => [plan];
}

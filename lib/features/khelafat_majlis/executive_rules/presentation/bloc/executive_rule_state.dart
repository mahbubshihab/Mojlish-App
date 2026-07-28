import 'package:equatable/equatable.dart';
import '../../domain/entities/executive_rule.dart';

abstract class ExecutiveRuleState extends Equatable {
  const ExecutiveRuleState();

  @override
  List<Object?> get props => [];
}

class ExecutiveRuleInitial extends ExecutiveRuleState {}

class ExecutiveRuleLoading extends ExecutiveRuleState {}

class ExecutiveRuleLoaded extends ExecutiveRuleState {
  final List<ExecutiveRule> rules;

  const ExecutiveRuleLoaded({required this.rules});

  @override
  List<Object?> get props => [rules];
}

class ExecutiveRuleError extends ExecutiveRuleState {
  final String message;

  const ExecutiveRuleError({required this.message});

  @override
  List<Object?> get props => [message];
}

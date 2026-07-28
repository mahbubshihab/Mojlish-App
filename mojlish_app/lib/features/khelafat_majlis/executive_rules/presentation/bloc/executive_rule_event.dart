import 'package:equatable/equatable.dart';

abstract class ExecutiveRuleEvent extends Equatable {
  const ExecutiveRuleEvent();

  @override
  List<Object?> get props => [];
}

class FetchExecutiveRulesEvent extends ExecutiveRuleEvent {}

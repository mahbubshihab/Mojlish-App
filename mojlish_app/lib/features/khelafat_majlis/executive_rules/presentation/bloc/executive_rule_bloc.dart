import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/executive_rule_repository.dart';
import 'executive_rule_event.dart';
import 'executive_rule_state.dart';

class ExecutiveRuleBloc extends Bloc<ExecutiveRuleEvent, ExecutiveRuleState> {
  final ExecutiveRuleRepository repository;

  ExecutiveRuleBloc({required this.repository}) : super(ExecutiveRuleInitial()) {
    on<FetchExecutiveRulesEvent>(_onFetchExecutiveRules);
  }

  Future<void> _onFetchExecutiveRules(
    FetchExecutiveRulesEvent event,
    Emitter<ExecutiveRuleState> emit,
  ) async {
    emit(ExecutiveRuleLoading());
    final result = await repository.getExecutiveRules();
    result.fold(
      (failure) => emit(ExecutiveRuleError(message: failure.message)),
      (rules) => emit(ExecutiveRuleLoaded(rules: rules)),
    );
  }
}

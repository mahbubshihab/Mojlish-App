import 'package:flutter_bloc/flutter_bloc.dart';
import 'executive_rules_event.dart';
import 'executive_rules_state.dart';

class KhelafatExecutiveRulesBloc extends Bloc<KhelafatExecutiveRulesEvent, KhelafatExecutiveRulesState> {
  KhelafatExecutiveRulesBloc() : super(KhelafatExecutiveRulesInitial()) {
    on<LoadKhelafatExecutiveRulesData>((event, emit) {
      emit(KhelafatExecutiveRulesLoading());
      emit(KhelafatExecutiveRulesLoaded());
    });
  }
}

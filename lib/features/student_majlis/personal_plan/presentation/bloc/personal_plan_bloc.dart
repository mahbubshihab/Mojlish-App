import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/personal_plan_repository.dart';
import 'personal_plan_event.dart';
import 'personal_plan_state.dart';

class PersonalPlanBloc extends Bloc<PersonalPlanEvent, PersonalPlanState> {
  final PersonalPlanRepository repository;

  PersonalPlanBloc({required this.repository}) : super(PersonalPlanInitial()) {
    on<SubmitPersonalPlanEvent>(_onSubmitPersonalPlan);
  }

  Future<void> _onSubmitPersonalPlan(
    SubmitPersonalPlanEvent event,
    Emitter<PersonalPlanState> emit,
  ) async {
    emit(PersonalPlanLoading());
    try {
      await repository.submitPersonalPlan(event.plan);
      emit(PersonalPlanSuccess());
    } catch (e) {
      emit(PersonalPlanError(e.toString()));
    }
  }
}

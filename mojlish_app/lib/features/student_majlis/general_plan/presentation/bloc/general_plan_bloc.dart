import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/general_plan_entity.dart';
import '../../domain/repositories/general_plan_repository.dart';

part 'general_plan_event.dart';
part 'general_plan_state.dart';

class GeneralPlanBloc extends Bloc<GeneralPlanEvent, GeneralPlanState> {
  final GeneralPlanRepository repository;

  GeneralPlanBloc({required this.repository}) : super(GeneralPlanInitial()) {
    on<SubmitGeneralPlanEvent>((event, emit) async {
      emit(GeneralPlanLoading());
      final result = await repository.submitGeneralPlan(event.plan);
      result.fold(
        (failure) => emit(const GeneralPlanError(message: 'Submission Failed')),
        (_) => emit(GeneralPlanSubmitted()),
      );
    });
  }
}

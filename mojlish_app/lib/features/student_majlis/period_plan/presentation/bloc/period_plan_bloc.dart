import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/period_plan.dart';
import '../../domain/repositories/period_plan_repository.dart';
import 'period_plan_event.dart';
import 'period_plan_state.dart';

class PeriodPlanBloc extends Bloc<PeriodPlanEvent, PeriodPlanState> {
  final PeriodPlanRepository repository;

  PeriodPlanBloc({required this.repository}) : super(PeriodPlanInitial()) {
    on<SubmitPeriodPlanEvent>((event, emit) async {
      emit(PeriodPlanLoading());
      try {
        await repository.submitPeriodPlan(PeriodPlan(
          branch: event.branch,
          month: event.month,
          session: event.session,
        ));
        emit(PeriodPlanSuccess());
      } catch (e) {
        emit(PeriodPlanFailure(e.toString()));
      }
    });
  }
}

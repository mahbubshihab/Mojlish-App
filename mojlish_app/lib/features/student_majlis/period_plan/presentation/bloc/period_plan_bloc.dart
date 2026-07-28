import 'package:flutter_bloc/flutter_bloc.dart';
import 'period_plan_event.dart';
import 'period_plan_state.dart';

class StudentPeriodPlanBloc extends Bloc<StudentPeriodPlanEvent, StudentPeriodPlanState> {
  StudentPeriodPlanBloc() : super(StudentPeriodPlanInitial()) {
    on<LoadStudentPeriodPlanData>((event, emit) {
      emit(StudentPeriodPlanLoading());
      emit(StudentPeriodPlanLoaded());
    });
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'general_plan_event.dart';
import 'general_plan_state.dart';

class StudentGeneralPlanBloc extends Bloc<StudentGeneralPlanEvent, StudentGeneralPlanState> {
  StudentGeneralPlanBloc() : super(StudentGeneralPlanInitial()) {
    on<LoadStudentGeneralPlanData>((event, emit) {
      emit(StudentGeneralPlanLoading());
      emit(StudentGeneralPlanLoaded());
    });
  }
}

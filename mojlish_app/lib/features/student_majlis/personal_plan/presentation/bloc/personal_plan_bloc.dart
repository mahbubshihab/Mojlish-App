import 'package:flutter_bloc/flutter_bloc.dart';
import 'personal_plan_event.dart';
import 'personal_plan_state.dart';

class StudentPersonalPlanBloc extends Bloc<StudentPersonalPlanEvent, StudentPersonalPlanState> {
  StudentPersonalPlanBloc() : super(StudentPersonalPlanInitial()) {
    on<LoadStudentPersonalPlanData>((event, emit) {
      emit(StudentPersonalPlanLoading());
      emit(StudentPersonalPlanLoaded());
    });
  }
}

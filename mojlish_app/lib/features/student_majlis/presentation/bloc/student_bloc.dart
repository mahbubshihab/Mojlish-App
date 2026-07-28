import 'package:flutter_bloc/flutter_bloc.dart';
import 'student_event.dart';
import 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc() : super(StudentInitial()) {
    on<LoadStudentPlan>((event, emit) {
      emit(StudentLoading());
      emit(StudentLoaded());
    });
  }
}

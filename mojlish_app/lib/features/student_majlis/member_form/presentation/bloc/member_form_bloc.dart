import 'package:flutter_bloc/flutter_bloc.dart';
import 'member_form_event.dart';
import 'member_form_state.dart';

class StudentMemberFormBloc extends Bloc<StudentMemberFormEvent, StudentMemberFormState> {
  StudentMemberFormBloc() : super(StudentMemberFormInitial()) {
    on<LoadStudentMemberFormData>((event, emit) {
      emit(StudentMemberFormLoading());
      emit(StudentMemberFormLoaded());
    });
  }
}

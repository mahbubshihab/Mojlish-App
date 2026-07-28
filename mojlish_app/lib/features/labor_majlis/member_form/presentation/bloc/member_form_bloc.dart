import 'package:flutter_bloc/flutter_bloc.dart';
import 'member_form_event.dart';
import 'member_form_state.dart';

class LaborMemberFormBloc extends Bloc<LaborMemberFormEvent, LaborMemberFormState> {
  LaborMemberFormBloc() : super(LaborMemberFormInitial()) {
    on<LoadLaborMemberFormData>((event, emit) {
      emit(LaborMemberFormLoading());
      emit(LaborMemberFormLoaded());
    });
  }
}

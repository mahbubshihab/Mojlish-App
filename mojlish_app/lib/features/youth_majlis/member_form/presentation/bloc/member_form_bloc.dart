import 'package:flutter_bloc/flutter_bloc.dart';
import 'member_form_event.dart';
import 'member_form_state.dart';

class YouthMemberFormBloc extends Bloc<YouthMemberFormEvent, YouthMemberFormState> {
  YouthMemberFormBloc() : super(YouthMemberFormInitial()) {
    on<LoadYouthMemberFormData>((event, emit) {
      emit(YouthMemberFormLoading());
      emit(YouthMemberFormLoaded());
    });
  }
}

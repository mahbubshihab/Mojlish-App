import 'package:flutter_bloc/flutter_bloc.dart';
import 'member_form_event.dart';
import 'member_form_state.dart';

class KhelafatMemberFormBloc extends Bloc<KhelafatMemberFormEvent, KhelafatMemberFormState> {
  KhelafatMemberFormBloc() : super(KhelafatMemberFormInitial()) {
    on<LoadKhelafatMemberFormData>((event, emit) {
      emit(KhelafatMemberFormLoading());
      emit(KhelafatMemberFormLoaded());
    });
  }
}

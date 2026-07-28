import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/member_repository.dart';
import 'member_form_event.dart';
import 'member_form_state.dart';

class MemberFormBloc extends Bloc<MemberFormEvent, MemberFormState> {
  final KhelafatMajlisMemberRepository repository;

  MemberFormBloc({required this.repository}) : super(MemberFormInitial()) {
    on<SubmitMemberForm>((event, emit) async {
      emit(MemberFormLoading());
      try {
        await repository.submitMemberForm(event.member);
        emit(MemberFormSuccess());
      } catch (e) {
        emit(MemberFormError(e.toString()));
      }
    });
  }
}

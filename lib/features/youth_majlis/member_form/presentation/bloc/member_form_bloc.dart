import 'package:flutter_bloc/flutter_bloc.dart';
import 'member_form_event.dart';
import 'member_form_state.dart';
import '../../domain/repositories/member_form_repository.dart';

class MemberFormBloc extends Bloc<MemberFormEvent, MemberFormState> {
  final MemberFormRepository repository;

  MemberFormBloc({required this.repository}) : super(MemberFormInitial()) {
    on<SubmitMemberForm>((event, emit) async {
      emit(MemberFormLoading());
      final result = await repository.submitMemberForm(event.entity);
      result.fold(
        (error) => emit(MemberFormFailure(errorMessage: error.toString())),
        (_) => emit(MemberFormSuccess()),
      );
    });
  }
}

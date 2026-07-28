import 'package:flutter_bloc/flutter_bloc.dart';
import 'member_form_event.dart';
import 'member_form_state.dart';
import '../../domain/repositories/member_form_repository.dart';
import '../../domain/entities/member_form_entity.dart';

class MemberFormBloc extends Bloc<MemberFormEvent, MemberFormState> {
  final MemberFormRepository repository;

  MemberFormBloc({required this.repository}) : super(MemberFormInitial()) {
    on<SubmitMemberFormEvent>((event, emit) async {
      emit(MemberFormLoading());
      try {
        final form = MemberFormEntity(
          name: event.name,
          fatherName: event.fatherName,
          educationalInstitution: event.educationalInstitution,
          bloodGroup: event.bloodGroup,
          studentClass: event.studentClass,
          department: event.department,
          rollNo: event.rollNo,
          presentAddress: event.presentAddress,
          mobile: event.mobile,
          permanentVillage: event.permanentVillage,
          permanentPostOffice: event.permanentPostOffice,
          permanentThana: event.permanentThana,
          permanentDistrict: event.permanentDistrict,
        );
        await repository.submitMemberForm(form);
        emit(MemberFormSuccess());
      } catch (e) {
        emit(MemberFormError(e.toString()));
      }
    });
  }
}

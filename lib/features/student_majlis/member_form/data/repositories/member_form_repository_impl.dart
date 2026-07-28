import '../../domain/entities/member_form_entity.dart';
import '../../domain/repositories/member_form_repository.dart';
import '../datasources/member_form_remote_datasource.dart';
import '../models/member_form_model.dart';

class MemberFormRepositoryImpl implements MemberFormRepository {
  final MemberFormRemoteDataSource remoteDataSource;

  MemberFormRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> submitMemberForm(MemberFormEntity form) async {
    final model = MemberFormModel(
      name: form.name,
      fatherName: form.fatherName,
      educationalInstitution: form.educationalInstitution,
      bloodGroup: form.bloodGroup,
      studentClass: form.studentClass,
      department: form.department,
      rollNo: form.rollNo,
      presentAddress: form.presentAddress,
      mobile: form.mobile,
      permanentVillage: form.permanentVillage,
      permanentPostOffice: form.permanentPostOffice,
      permanentThana: form.permanentThana,
      permanentDistrict: form.permanentDistrict,
    );
    await remoteDataSource.submitForm(model);
  }
}

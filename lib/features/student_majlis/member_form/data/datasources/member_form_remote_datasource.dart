import 'package:mojlish_app/core/services/member_application_submission_service.dart';
import '../models/member_form_model.dart';

abstract class MemberFormRemoteDataSource {
  Future<void> submitForm(MemberFormModel formModel);
}

class MemberFormRemoteDataSourceImpl implements MemberFormRemoteDataSource {
  @override
  Future<void> submitForm(MemberFormModel formModel) async {
    await MemberApplicationSubmissionService.submitApplication(
      majlis: 'বাংলাদেশ ইসলামী ছাত্র মজলিস',
      name: formModel.name,
      mobile: formModel.mobile,
      fatherName: formModel.fatherName,
      educationalQualification: '${formModel.educationalInstitution} (${formModel.department})',
      profession: 'ছাত্র',
      presentAddress: formModel.presentAddress,
      permanentAddress: '${formModel.permanentVillage}, ${formModel.permanentPostOffice}, ${formModel.permanentThana}, ${formModel.permanentDistrict}',
      branchOrDistrict: formModel.permanentDistrict,
      additionalData: {
        'bloodGroup': formModel.bloodGroup,
        'studentClass': formModel.studentClass,
        'department': formModel.department,
        'rollNo': formModel.rollNo,
      },
    );
  }
}

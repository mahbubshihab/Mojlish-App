import 'package:mojlish_app/core/services/member_application_submission_service.dart';
import '../models/member_model.dart';

abstract class MemberRemoteDataSource {
  Future<void> submitMemberForm(KhelafatMajlisMemberModel member);
}

class MemberRemoteDataSourceImpl implements MemberRemoteDataSource {
  @override
  Future<void> submitMemberForm(KhelafatMajlisMemberModel member) async {
    await MemberApplicationSubmissionService.submitApplication(
      majlis: 'খেলাফত মজলিস',
      name: member.name,
      mobile: member.mobile,
      fatherName: member.fatherName,
      educationalQualification: member.educationalQualification,
      age: member.age,
      profession: member.profession,
      presentAddress: member.presentAddress,
      permanentAddress: member.permanentAddress,
    );
  }
}

import 'package:mojlish_app/core/services/member_application_submission_service.dart';
import '../models/member_form_model.dart';

abstract class MemberFormRemoteDataSource {
  Future<void> submitMemberForm(MemberFormModel formModel);
}

class MemberFormRemoteDataSourceImpl implements MemberFormRemoteDataSource {
  @override
  Future<void> submitMemberForm(MemberFormModel formModel) async {
    await MemberApplicationSubmissionService.submitApplication(
      majlis: 'বাংলাদেশ ইসলামী যুব মজলিস',
      name: formModel.name,
      mobile: formModel.mobile,
      fatherName: formModel.fatherName,
      presentAddress: formModel.presentAddress,
      permanentAddress: '${formModel.village}, ${formModel.unionName}, ${formModel.thanaUpazila}',
      branchOrDistrict: formModel.district,
      additionalData: {
        'nidNumber': formModel.nidNumber,
        'email': formModel.email ?? '',
      },
    );
  }
}

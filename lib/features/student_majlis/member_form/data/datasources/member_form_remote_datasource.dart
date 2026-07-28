import '../models/member_form_model.dart';

abstract class MemberFormRemoteDataSource {
  Future<void> submitForm(MemberFormModel formModel);
}

class MemberFormRemoteDataSourceImpl implements MemberFormRemoteDataSource {
  @override
  Future<void> submitForm(MemberFormModel formModel) async {
    // Mock API call
    await Future.delayed(const Duration(seconds: 1));
  }
}

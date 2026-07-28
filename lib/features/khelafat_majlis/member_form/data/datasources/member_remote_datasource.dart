import '../models/member_model.dart';

abstract class MemberRemoteDataSource {
  Future<void> submitMemberForm(KhelafatMajlisMemberModel member);
}

class MemberRemoteDataSourceImpl implements MemberRemoteDataSource {
  @override
  Future<void> submitMemberForm(KhelafatMajlisMemberModel member) async {
    // Simulate network call
    await Future.delayed(const Duration(seconds: 1));
  }
}

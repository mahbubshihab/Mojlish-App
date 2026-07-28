import '../entities/member.dart';

abstract class KhelafatMajlisMemberRepository {
  Future<void> submitMemberForm(KhelafatMajlisMember member);
}

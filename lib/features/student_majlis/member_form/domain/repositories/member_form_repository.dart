import '../entities/member_form_entity.dart';

abstract class MemberFormRepository {
  Future<void> submitMemberForm(MemberFormEntity form);
}

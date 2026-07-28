import '../entities/member_form_entity.dart';
import 'package:dartz/dartz.dart';

abstract class MemberFormRepository {
  Future<Either<Exception, void>> submitMemberForm(MemberFormEntity entity);
}

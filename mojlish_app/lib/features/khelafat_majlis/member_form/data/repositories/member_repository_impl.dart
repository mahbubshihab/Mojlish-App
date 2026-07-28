import '../../domain/entities/member.dart';
import '../../domain/repositories/member_repository.dart';
import '../datasources/member_remote_datasource.dart';
import '../models/member_model.dart';

class KhelafatMajlisMemberRepositoryImpl implements KhelafatMajlisMemberRepository {
  final MemberRemoteDataSource remoteDataSource;

  KhelafatMajlisMemberRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> submitMemberForm(KhelafatMajlisMember member) async {
    final memberModel = KhelafatMajlisMemberModel(
      id: member.id,
      name: member.name,
      fatherName: member.fatherName,
      educationalQualification: member.educationalQualification,
      age: member.age,
      profession: member.profession,
      presentAddress: member.presentAddress,
      mobile: member.mobile,
      permanentAddress: member.permanentAddress,
      date: member.date,
    );
    await remoteDataSource.submitMemberForm(memberModel);
  }
}

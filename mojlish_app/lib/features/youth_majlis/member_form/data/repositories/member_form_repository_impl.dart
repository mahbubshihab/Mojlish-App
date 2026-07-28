import 'package:dartz/dartz.dart';
import 'package:mojlish_app/features/youth_majlis/member_form/domain/entities/member_form_entity.dart';
import 'package:mojlish_app/features/youth_majlis/member_form/domain/repositories/member_form_repository.dart';
import '../datasources/member_form_remote_datasource.dart';
import '../models/member_form_model.dart';

class MemberFormRepositoryImpl implements MemberFormRepository {
  final MemberFormRemoteDataSource remoteDataSource;

  MemberFormRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Exception, void>> submitMemberForm(MemberFormEntity entity) async {
    try {
      final model = MemberFormModel(
        id: entity.id,
        name: entity.name,
        fatherName: entity.fatherName,
        nidNumber: entity.nidNumber,
        village: entity.village,
        unionName: entity.unionName,
        thanaUpazila: entity.thanaUpazila,
        district: entity.district,
        presentAddress: entity.presentAddress,
        mobile: entity.mobile,
        email: entity.email,
        joinDate: entity.joinDate,
        signatureUrl: entity.signatureUrl,
      );
      await remoteDataSource.submitMemberForm(model);
      return const Right(null);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}

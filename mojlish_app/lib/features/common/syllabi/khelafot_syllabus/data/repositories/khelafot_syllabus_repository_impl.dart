import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../domain/entities/khelafot_syllabus_entity.dart';
import '../../domain/repositories/khelafot_syllabus_repository.dart';
import '../datasources/khelafot_syllabus_remote_datasource.dart';

class KhelafotSyllabusRepositoryImpl implements KhelafotSyllabusRepository {
  final KhelafotSyllabusRemoteDataSource remoteDataSource;

  KhelafotSyllabusRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<KhelafotSyllabusEntity>>> getSyllabi() async {
    try {
      final syllabi = await remoteDataSource.getSyllabi();
      return Right(syllabi);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

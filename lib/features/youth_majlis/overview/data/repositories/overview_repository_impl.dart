import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/overview_entity.dart';
import '../../domain/repositories/overview_repository.dart';
import '../datasources/overview_remote_datasource.dart';

class OverviewRepositoryImpl implements OverviewRepository {
  final OverviewRemoteDataSource remoteDataSource;

  OverviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OverviewEntity>> getOverview() async {
    try {
      final remoteOverview = await remoteDataSource.getOverview();
      return Right(remoteOverview);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

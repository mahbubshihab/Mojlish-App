import 'package:dartz/dartz.dart';
import '../../domain/entities/overview_entity.dart';
import '../../domain/repositories/overview_repository.dart';
import '../datasources/overview_remote_data_source.dart';

class OverviewRepositoryImpl implements OverviewRepository {
  final OverviewRemoteDataSource remoteDataSource;

  OverviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, OverviewEntity>> getOverview() async {
    try {
      final overview = await remoteDataSource.getOverview();
      return Right(overview);
    } catch (e) {
      return Left('ডাটা লোড করতে ব্যর্থ হয়েছে: ${e.toString()}');
    }
  }
}

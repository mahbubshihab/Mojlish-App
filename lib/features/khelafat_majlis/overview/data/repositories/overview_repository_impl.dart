import '../../domain/entities/overview_entity.dart';
import '../../domain/repositories/overview_repository.dart';
import '../datasources/overview_remote_data_source.dart';

class OverviewRepositoryImpl implements OverviewRepository {
  final OverviewRemoteDataSource remoteDataSource;

  OverviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<OverviewEntity> getOverview() async {
    try {
      final model = await remoteDataSource.getOverview();
      return model;
    } catch (e) {
      throw Exception('Failed to load overview data');
    }
  }
}

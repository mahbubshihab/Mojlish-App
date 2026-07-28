import '../entities/overview_entity.dart';

abstract class OverviewRepository {
  Future<OverviewEntity> getOverview();
}

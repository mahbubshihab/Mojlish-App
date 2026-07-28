import '../../domain/entities/call_manifesto.dart';
import '../../domain/repositories/call_manifesto_repository.dart';
import '../datasources/call_manifesto_datasource.dart';

class CallManifestoRepositoryImpl implements CallManifestoRepository {
  final CallManifestoDataSource dataSource;

  CallManifestoRepositoryImpl(this.dataSource);

  @override
  Future<List<CallManifesto>> getCallManifestos() async {
    try {
      final models = await dataSource.getCallManifestos();
      return models;
    } catch (e) {
      throw Exception('Failed to load call manifestos');
    }
  }
}

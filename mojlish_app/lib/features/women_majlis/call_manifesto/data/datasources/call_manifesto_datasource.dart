import '../models/call_manifesto_model.dart';

abstract class CallManifestoDataSource {
  Future<List<CallManifestoModel>> getCallManifestos();
}

class CallManifestoDataSourceImpl implements CallManifestoDataSource {
  @override
  Future<List<CallManifestoModel>> getCallManifestos() async {
    // TODO: Implement actual remote/local data fetching
    return [
      CallManifestoModel(
        id: '1',
        title: 'Ahobban (Call)',
        content: 'Our call to the women of the majlis to unite and build a better future together.',
        imageUrl: '',
        createdAt: DateTime.now(),
      ),
    ];
  }
}

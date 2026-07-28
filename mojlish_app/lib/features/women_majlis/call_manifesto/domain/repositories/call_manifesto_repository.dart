import '../entities/call_manifesto.dart';

abstract class CallManifestoRepository {
  Future<List<CallManifesto>> getCallManifestos();
}

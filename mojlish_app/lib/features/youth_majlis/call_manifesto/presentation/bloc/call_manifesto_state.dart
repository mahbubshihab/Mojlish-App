import '../../domain/entities/call_manifesto.dart';

abstract class CallManifestoState {}

class CallManifestoInitial extends CallManifestoState {}

class CallManifestoLoading extends CallManifestoState {}

class CallManifestoLoaded extends CallManifestoState {
  final List<CallManifesto> manifestos;

  CallManifestoLoaded(this.manifestos);
}

class CallManifestoError extends CallManifestoState {
  final String message;

  CallManifestoError(this.message);
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/call_manifesto_repository.dart';
import 'call_manifesto_event.dart';
import 'call_manifesto_state.dart';

class CallManifestoBloc extends Bloc<CallManifestoEvent, CallManifestoState> {
  final CallManifestoRepository repository;

  CallManifestoBloc({required this.repository}) : super(CallManifestoInitial()) {
    on<LoadCallManifestosEvent>((event, emit) async {
      emit(CallManifestoLoading());
      try {
        final manifestos = await repository.getCallManifestos();
        emit(CallManifestoLoaded(manifestos));
      } catch (e) {
        emit(CallManifestoError(e.toString()));
      }
    });
  }
}

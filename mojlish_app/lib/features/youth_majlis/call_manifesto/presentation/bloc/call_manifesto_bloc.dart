import 'package:flutter_bloc/flutter_bloc.dart';
import 'call_manifesto_event.dart';
import 'call_manifesto_state.dart';

class YouthCallManifestoBloc extends Bloc<YouthCallManifestoEvent, YouthCallManifestoState> {
  YouthCallManifestoBloc() : super(YouthCallManifestoInitial()) {
    on<LoadYouthCallManifestoData>((event, emit) {
      emit(YouthCallManifestoLoading());
      emit(YouthCallManifestoLoaded());
    });
  }
}

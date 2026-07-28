import 'package:flutter_bloc/flutter_bloc.dart';
import 'call_manifesto_event.dart';
import 'call_manifesto_state.dart';

class WomenCallManifestoBloc extends Bloc<WomenCallManifestoEvent, WomenCallManifestoState> {
  WomenCallManifestoBloc() : super(WomenCallManifestoInitial()) {
    on<LoadWomenCallManifestoData>((event, emit) {
      emit(WomenCallManifestoLoading());
      emit(WomenCallManifestoLoaded());
    });
  }
}

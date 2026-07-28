import 'package:flutter_bloc/flutter_bloc.dart';
import 'khelafat_event.dart';
import 'khelafat_state.dart';

class KhelafatBloc extends Bloc<KhelafatEvent, KhelafatState> {
  KhelafatBloc() : super(KhelafatInitial()) {
    on<LoadKhelafatData>((event, emit) {
      emit(KhelafatLoading());
      emit(KhelafatLoaded());
    });
  }
}

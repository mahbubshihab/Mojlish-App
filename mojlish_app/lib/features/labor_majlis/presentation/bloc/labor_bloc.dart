import 'package:flutter_bloc/flutter_bloc.dart';
import 'labor_event.dart';
import 'labor_state.dart';

class LaborBloc extends Bloc<LaborEvent, LaborState> {
  LaborBloc() : super(LaborInitial()) {
    on<LoadLaborData>((event, emit) {
      emit(LaborLoading());
      emit(LaborLoaded());
    });
  }
}

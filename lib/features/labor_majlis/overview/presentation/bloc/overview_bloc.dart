import 'package:flutter_bloc/flutter_bloc.dart';
import 'overview_event.dart';
import 'overview_state.dart';

class LaborOverviewBloc extends Bloc<LaborOverviewEvent, LaborOverviewState> {
  LaborOverviewBloc() : super(LaborOverviewInitial()) {
    on<LoadLaborOverviewData>((event, emit) {
      emit(LaborOverviewLoading());
      emit(LaborOverviewLoaded());
    });
  }
}

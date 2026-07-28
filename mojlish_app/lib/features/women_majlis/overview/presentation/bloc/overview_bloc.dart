import 'package:flutter_bloc/flutter_bloc.dart';
import 'overview_event.dart';
import 'overview_state.dart';

class WomenOverviewBloc extends Bloc<WomenOverviewEvent, WomenOverviewState> {
  WomenOverviewBloc() : super(WomenOverviewInitial()) {
    on<LoadWomenOverviewData>((event, emit) {
      emit(WomenOverviewLoading());
      emit(WomenOverviewLoaded());
    });
  }
}

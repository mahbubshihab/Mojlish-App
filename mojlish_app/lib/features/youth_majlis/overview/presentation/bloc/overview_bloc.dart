import 'package:flutter_bloc/flutter_bloc.dart';
import 'overview_event.dart';
import 'overview_state.dart';

class YouthOverviewBloc extends Bloc<YouthOverviewEvent, YouthOverviewState> {
  YouthOverviewBloc() : super(YouthOverviewInitial()) {
    on<LoadYouthOverviewData>((event, emit) {
      emit(YouthOverviewLoading());
      emit(YouthOverviewLoaded());
    });
  }
}

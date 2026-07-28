import 'package:flutter_bloc/flutter_bloc.dart';
import 'overview_event.dart';
import 'overview_state.dart';

class KhelafatOverviewBloc extends Bloc<KhelafatOverviewEvent, KhelafatOverviewState> {
  KhelafatOverviewBloc() : super(KhelafatOverviewInitial()) {
    on<LoadKhelafatOverviewData>((event, emit) {
      emit(KhelafatOverviewLoading());
      emit(KhelafatOverviewLoaded());
    });
  }
}

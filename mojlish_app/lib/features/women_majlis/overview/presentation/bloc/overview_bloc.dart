import 'package:flutter_bloc/flutter_bloc.dart';
import 'overview_event.dart';
import 'overview_state.dart';
import '../../domain/repositories/overview_repository.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  final OverviewRepository repository;

  OverviewBloc({required this.repository}) : super(OverviewInitial()) {
    on<LoadOverviewEvent>((event, emit) async {
      emit(OverviewLoading());
      try {
        final overview = await repository.getOverview();
        emit(OverviewLoaded(overview: overview));
      } catch (e) {
        emit(OverviewError(message: e.toString()));
      }
    });
  }
}

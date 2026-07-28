import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/overview_repository.dart';
import 'overview_event.dart';
import 'overview_state.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  final OverviewRepository repository;

  OverviewBloc({required this.repository}) : super(OverviewInitial()) {
    on<LoadOverviewEvent>((event, emit) async {
      emit(OverviewLoading());
      final result = await repository.getOverview();
      result.fold(
        (failure) => emit(OverviewError(message: 'Failed to load data')),
        (overview) => emit(OverviewLoaded(overview: overview)),
      );
    });
  }
}

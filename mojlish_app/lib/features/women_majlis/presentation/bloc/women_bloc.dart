import 'package:flutter_bloc/flutter_bloc.dart';
import 'women_event.dart';
import 'women_state.dart';

class WomenBloc extends Bloc<WomenEvent, WomenState> {
  WomenBloc() : super(WomenInitial()) {
    on<LoadWomenData>((event, emit) {
      emit(WomenLoading());
      emit(WomenLoaded());
    });
  }
}

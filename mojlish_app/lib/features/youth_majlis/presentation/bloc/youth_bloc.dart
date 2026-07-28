import 'package:flutter_bloc/flutter_bloc.dart';
import 'youth_event.dart';
import 'youth_state.dart';

class YouthBloc extends Bloc<YouthEvent, YouthState> {
  YouthBloc() : super(YouthInitial()) {
    on<LoadYouthData>((event, emit) {
      emit(YouthLoading());
      emit(YouthLoaded());
    });
  }
}

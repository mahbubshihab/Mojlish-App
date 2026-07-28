import 'package:flutter_bloc/flutter_bloc.dart';
import 'personal_report_event.dart';
import 'personal_report_state.dart';

class WomenPersonalReportBloc extends Bloc<WomenPersonalReportEvent, WomenPersonalReportState> {
  WomenPersonalReportBloc() : super(WomenPersonalReportInitial()) {
    on<LoadWomenPersonalReportData>((event, emit) {
      emit(WomenPersonalReportLoading());
      emit(WomenPersonalReportLoaded());
    });
  }
}

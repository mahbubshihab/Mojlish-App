import 'package:flutter_bloc/flutter_bloc.dart';
import 'baytulmal_report_event.dart';
import 'baytulmal_report_state.dart';

class KhelafatBaytulmalReportBloc extends Bloc<KhelafatBaytulmalReportEvent, KhelafatBaytulmalReportState> {
  KhelafatBaytulmalReportBloc() : super(KhelafatBaytulmalReportInitial()) {
    on<LoadKhelafatBaytulmalReportData>((event, emit) {
      emit(KhelafatBaytulmalReportLoading());
      emit(KhelafatBaytulmalReportLoaded());
    });
  }
}

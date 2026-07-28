import 'package:flutter_bloc/flutter_bloc.dart';
import 'personal_report_event.dart';
import 'personal_report_state.dart';

class KhelafatPersonalReportBloc extends Bloc<KhelafatPersonalReportEvent, KhelafatPersonalReportState> {
  KhelafatPersonalReportBloc() : super(KhelafatPersonalReportInitial()) {
    on<LoadKhelafatPersonalReportData>((event, emit) {
      emit(KhelafatPersonalReportLoading());
      emit(KhelafatPersonalReportLoaded());
    });
  }
}

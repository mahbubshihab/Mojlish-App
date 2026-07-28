import 'package:flutter_bloc/flutter_bloc.dart';
import 'personal_report_event.dart';
import 'personal_report_state.dart';

class LaborPersonalReportBloc extends Bloc<LaborPersonalReportEvent, LaborPersonalReportState> {
  LaborPersonalReportBloc() : super(LaborPersonalReportInitial()) {
    on<LoadLaborPersonalReportData>((event, emit) {
      emit(LaborPersonalReportLoading());
      emit(LaborPersonalReportLoaded());
    });
  }
}

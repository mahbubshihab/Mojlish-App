import 'package:flutter_bloc/flutter_bloc.dart';
import 'personal_report_event.dart';
import 'personal_report_state.dart';

class YouthPersonalReportBloc extends Bloc<YouthPersonalReportEvent, YouthPersonalReportState> {
  YouthPersonalReportBloc() : super(YouthPersonalReportInitial()) {
    on<LoadYouthPersonalReportData>((event, emit) {
      emit(YouthPersonalReportLoading());
      emit(YouthPersonalReportLoaded());
    });
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'period_report_event.dart';
import 'period_report_state.dart';

class StudentPeriodReportBloc extends Bloc<StudentPeriodReportEvent, StudentPeriodReportState> {
  StudentPeriodReportBloc() : super(StudentPeriodReportInitial()) {
    on<LoadStudentPeriodReportData>((event, emit) {
      emit(StudentPeriodReportLoading());
      emit(StudentPeriodReportLoaded());
    });
  }
}

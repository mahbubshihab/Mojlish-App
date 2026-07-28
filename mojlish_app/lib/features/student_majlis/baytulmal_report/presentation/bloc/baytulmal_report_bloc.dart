import 'package:flutter_bloc/flutter_bloc.dart';
import 'baytulmal_report_event.dart';
import 'baytulmal_report_state.dart';

class StudentBaytulmalReportBloc extends Bloc<StudentBaytulmalReportEvent, StudentBaytulmalReportState> {
  StudentBaytulmalReportBloc() : super(StudentBaytulmalReportInitial()) {
    on<LoadStudentBaytulmalReportData>((event, emit) {
      emit(StudentBaytulmalReportLoading());
      emit(StudentBaytulmalReportLoaded());
    });
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'personal_report_event.dart';
import 'personal_report_state.dart';

class StudentPersonalReportBloc extends Bloc<StudentPersonalReportEvent, StudentPersonalReportState> {
  StudentPersonalReportBloc() : super(StudentPersonalReportInitial()) {
    on<LoadStudentPersonalReportData>((event, emit) {
      emit(StudentPersonalReportLoading());
      emit(StudentPersonalReportLoaded());
    });
  }
}

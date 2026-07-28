import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/student_period_storage_service.dart';
import 'period_report_event.dart';
import 'period_report_state.dart';

class StudentPeriodReportBloc extends Bloc<StudentPeriodReportEvent, StudentPeriodReportState> {
  StudentPeriodReportBloc() : super(StudentPeriodReportInitial()) {
    on<LoadStudentPeriodReport>(_onLoadReport);
    on<SaveStudentPeriodReport>(_onSaveReport);
    on<UpdateStudentPeriodReport>(_onUpdateReport);
  }

  Future<void> _onLoadReport(
    LoadStudentPeriodReport event,
    Emitter<StudentPeriodReportState> emit,
  ) async {
    emit(StudentPeriodReportLoading());
    try {
      final report = await StudentPeriodStorageService.getReport(
        periodType: event.periodType,
        year: event.year,
        periodName: event.periodName,
      );
      emit(StudentPeriodReportLoaded(report: report));
    } catch (e) {
      emit(StudentPeriodReportError('ডেটা লোড করতে সমস্যা হয়েছে: $e'));
    }
  }

  Future<void> _onSaveReport(
    SaveStudentPeriodReport event,
    Emitter<StudentPeriodReportState> emit,
  ) async {
    if (state is StudentPeriodReportLoaded) {
      final currentState = state as StudentPeriodReportLoaded;
      emit(currentState.copyWith(isSaving: true));
      try {
        await StudentPeriodStorageService.saveReport(event.report);
        emit(currentState.copyWith(
          report: event.report,
          isSaving: false,
          message: 'রিপোর্ট সফলভাবে সংরক্ষিত হয়েছে!',
        ));
      } catch (e) {
        emit(currentState.copyWith(
          isSaving: false,
          message: 'সংরক্ষণে ব্যর্থ হয়েছে: $e',
        ));
      }
    }
  }

  void _onUpdateReport(
    UpdateStudentPeriodReport event,
    Emitter<StudentPeriodReportState> emit,
  ) {
    if (state is StudentPeriodReportLoaded) {
      final currentState = state as StudentPeriodReportLoaded;
      emit(currentState.copyWith(report: event.report));
    }
  }
}

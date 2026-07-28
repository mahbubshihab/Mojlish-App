import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mojlish_app/features/common/reports/shared/data/services/report_storage_service.dart';
import 'period_plan_event.dart';
import 'period_plan_state.dart';

class StudentPeriodPlanBloc extends Bloc<StudentPeriodPlanEvent, StudentPeriodPlanState> {
  StudentPeriodPlanBloc() : super(StudentPeriodPlanInitial()) {
    on<FetchStudentPeriodPlan>(_onFetchStudentPeriodPlan);
    on<SaveStudentPeriodPlan>(_onSaveStudentPeriodPlan);
  }

  Future<void> _onFetchStudentPeriodPlan(
    FetchStudentPeriodPlan event,
    Emitter<StudentPeriodPlanState> emit,
  ) async {
    emit(StudentPeriodPlanLoading());
    try {
      final plan = await ReportStorageService.getChatroMonthlyPlan(event.year, event.month);
      emit(StudentPeriodPlanLoaded(plan: plan));
    } catch (e) {
      emit(StudentPeriodPlanError('পরিকল্পনা ডাটা লোড করতে ব্যর্থ হয়েছে: ${e.toString()}'));
    }
  }

  Future<void> _onSaveStudentPeriodPlan(
    SaveStudentPeriodPlan event,
    Emitter<StudentPeriodPlanState> emit,
  ) async {
    emit(StudentPeriodPlanLoading());
    try {
      await ReportStorageService.saveChatroMonthlyPlan(event.plan);
      emit(StudentPeriodPlanSaved());
      emit(StudentPeriodPlanLoaded(plan: event.plan));
    } catch (e) {
      emit(StudentPeriodPlanError('পরিকল্পনা সংরক্ষণ করতে ব্যর্থ হয়েছে: ${e.toString()}'));
    }
  }
}

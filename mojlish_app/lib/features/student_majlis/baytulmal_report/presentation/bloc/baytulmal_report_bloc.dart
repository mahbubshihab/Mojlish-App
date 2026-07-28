import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/baytulmal_report_entity.dart';
import '../../domain/repositories/baytulmal_report_repository.dart';
import '../../data/repositories/baytulmal_report_repository_impl.dart';
import 'baytulmal_report_event.dart';
import 'baytulmal_report_state.dart';

class StudentBaytulmalReportBloc
    extends Bloc<StudentBaytulmalReportEvent, StudentBaytulmalReportState> {
  final StudentBaytulmalReportRepository repository;

  StudentBaytulmalReportBloc({StudentBaytulmalReportRepository? repository})
      : repository = repository ?? StudentBaytulmalReportRepositoryImpl(),
        super(StudentBaytulmalReportInitial()) {
    on<LoadStudentBaytulmalReportData>(_onLoadData);
    on<SaveStudentBaytulmalReportData>(_onSaveData);
    on<AddCustomIncomeRowEvent>(_onAddIncomeRow);
    on<RemoveCustomIncomeRowEvent>(_onRemoveIncomeRow);
    on<AddCustomExpenseRowEvent>(_onAddExpenseRow);
    on<RemoveCustomExpenseRowEvent>(_onRemoveExpenseRow);
    on<ToggleLockStatusEvent>(_onToggleLock);
  }

  Future<void> _onLoadData(
    LoadStudentBaytulmalReportData event,
    Emitter<StudentBaytulmalReportState> emit,
  ) async {
    emit(StudentBaytulmalReportLoading());
    try {
      final report = await repository.getReport(event.year, event.month);
      if (report != null) {
        emit(StudentBaytulmalReportLoaded(report: report, isLocked: true));
      } else {
        // Initial empty report
        final newReport = StudentBaytulmalReportEntity(
          id: '${event.year}-${event.month}',
          year: event.year,
          month: event.month,
          session: '${event.year}',
        );
        emit(StudentBaytulmalReportLoaded(report: newReport, isLocked: false));
      }
    } catch (e) {
      emit(StudentBaytulmalReportError(message: e.toString()));
    }
  }

  Future<void> _onSaveData(
    SaveStudentBaytulmalReportData event,
    Emitter<StudentBaytulmalReportState> emit,
  ) async {
    final currentState = state;
    if (currentState is StudentBaytulmalReportLoaded) {
      emit(currentState.copyWith(isSaving: true));
      try {
        await repository.saveReport(event.report);
        emit(currentState.copyWith(
          report: event.report,
          isSaving: false,
          isLocked: true,
          successMessage: 'বায়তুলমাল রিপোর্ট সফলভাবে সেভ করা হয়েছে ✓',
        ));
      } catch (e) {
        emit(currentState.copyWith(
          isSaving: false,
          errorMessage: 'সেভ করতে সমস্যা হয়েছে: $e',
        ));
      }
    }
  }

  void _onAddIncomeRow(
    AddCustomIncomeRowEvent event,
    Emitter<StudentBaytulmalReportState> emit,
  ) {
    if (state is StudentBaytulmalReportLoaded) {
      final loaded = state as StudentBaytulmalReportLoaded;
      final updatedList = List<StudentBaytulmalRowItem>.from(loaded.report.customIncomeRows)
        ..add(StudentBaytulmalRowItem(title: event.title.isEmpty ? 'অন্যান্য আয়' : event.title));

      final updatedReport = StudentBaytulmalReportEntity(
        id: loaded.report.id,
        year: loaded.report.year,
        month: loaded.report.month,
        session: loaded.report.session,
        branchName: loaded.report.branchName,
        jonoshaktiAyanatTaka: loaded.report.jonoshaktiAyanatTaka,
        jonoshaktiAyanatPaisa: loaded.report.jonoshaktiAyanatPaisa,
        shakhaAyanatTaka: loaded.report.shakhaAyanatTaka,
        shakhaAyanatPaisa: loaded.report.shakhaAyanatPaisa,
        suhridAyanatTaka: loaded.report.suhridAyanatTaka,
        suhridAyanatPaisa: loaded.report.suhridAyanatPaisa,
        ekkalinIncomeTaka: loaded.report.ekkalinIncomeTaka,
        ekkalinIncomePaisa: loaded.report.ekkalinIncomePaisa,
        customIncomeRows: updatedList,
        incomeInWords: loaded.report.incomeInWords,
        previousSurplusTaka: loaded.report.previousSurplusTaka,
        previousSurplusPaisa: loaded.report.previousSurplusPaisa,
        upwardAyanatTaka: loaded.report.upwardAyanatTaka,
        upwardAyanatPaisa: loaded.report.upwardAyanatPaisa,
        upwardSafarTaka: loaded.report.upwardSafarTaka,
        upwardSafarPaisa: loaded.report.upwardSafarPaisa,
        officeTaka: loaded.report.officeTaka,
        officePaisa: loaded.report.officePaisa,
        transportTaka: loaded.report.transportTaka,
        transportPaisa: loaded.report.transportPaisa,
        communicationTaka: loaded.report.communicationTaka,
        communicationPaisa: loaded.report.communicationPaisa,
        procharTaka: loaded.report.procharTaka,
        procharPaisa: loaded.report.procharPaisa,
        customExpenseRows: loaded.report.customExpenseRows,
        expenseInWords: loaded.report.expenseInWords,
        previousDeficitTaka: loaded.report.previousDeficitTaka,
        previousDeficitPaisa: loaded.report.previousDeficitPaisa,
      );

      emit(loaded.copyWith(report: updatedReport));
    }
  }

  void _onRemoveIncomeRow(
    RemoveCustomIncomeRowEvent event,
    Emitter<StudentBaytulmalReportState> emit,
  ) {
    if (state is StudentBaytulmalReportLoaded) {
      final loaded = state as StudentBaytulmalReportLoaded;
      final updatedList = List<StudentBaytulmalRowItem>.from(loaded.report.customIncomeRows);
      if (event.index >= 0 && event.index < updatedList.length) {
        updatedList.removeAt(event.index);
      }

      final updatedReport = StudentBaytulmalReportEntity(
        id: loaded.report.id,
        year: loaded.report.year,
        month: loaded.report.month,
        session: loaded.report.session,
        branchName: loaded.report.branchName,
        jonoshaktiAyanatTaka: loaded.report.jonoshaktiAyanatTaka,
        jonoshaktiAyanatPaisa: loaded.report.jonoshaktiAyanatPaisa,
        shakhaAyanatTaka: loaded.report.shakhaAyanatTaka,
        shakhaAyanatPaisa: loaded.report.shakhaAyanatPaisa,
        suhridAyanatTaka: loaded.report.suhridAyanatTaka,
        suhridAyanatPaisa: loaded.report.suhridAyanatPaisa,
        ekkalinIncomeTaka: loaded.report.ekkalinIncomeTaka,
        ekkalinIncomePaisa: loaded.report.ekkalinIncomePaisa,
        customIncomeRows: updatedList,
        incomeInWords: loaded.report.incomeInWords,
        previousSurplusTaka: loaded.report.previousSurplusTaka,
        previousSurplusPaisa: loaded.report.previousSurplusPaisa,
        upwardAyanatTaka: loaded.report.upwardAyanatTaka,
        upwardAyanatPaisa: loaded.report.upwardAyanatPaisa,
        upwardSafarTaka: loaded.report.upwardSafarTaka,
        upwardSafarPaisa: loaded.report.upwardSafarPaisa,
        officeTaka: loaded.report.officeTaka,
        officePaisa: loaded.report.officePaisa,
        transportTaka: loaded.report.transportTaka,
        transportPaisa: loaded.report.transportPaisa,
        communicationTaka: loaded.report.communicationTaka,
        communicationPaisa: loaded.report.communicationPaisa,
        procharTaka: loaded.report.procharTaka,
        procharPaisa: loaded.report.procharPaisa,
        customExpenseRows: loaded.report.customExpenseRows,
        expenseInWords: loaded.report.expenseInWords,
        previousDeficitTaka: loaded.report.previousDeficitTaka,
        previousDeficitPaisa: loaded.report.previousDeficitPaisa,
      );

      emit(loaded.copyWith(report: updatedReport));
    }
  }

  void _onAddExpenseRow(
    AddCustomExpenseRowEvent event,
    Emitter<StudentBaytulmalReportState> emit,
  ) {
    if (state is StudentBaytulmalReportLoaded) {
      final loaded = state as StudentBaytulmalReportLoaded;
      final updatedList = List<StudentBaytulmalRowItem>.from(loaded.report.customExpenseRows)
        ..add(StudentBaytulmalRowItem(title: event.title.isEmpty ? 'অন্যান্য ব্যয়' : event.title));

      final updatedReport = StudentBaytulmalReportEntity(
        id: loaded.report.id,
        year: loaded.report.year,
        month: loaded.report.month,
        session: loaded.report.session,
        branchName: loaded.report.branchName,
        jonoshaktiAyanatTaka: loaded.report.jonoshaktiAyanatTaka,
        jonoshaktiAyanatPaisa: loaded.report.jonoshaktiAyanatPaisa,
        shakhaAyanatTaka: loaded.report.shakhaAyanatTaka,
        shakhaAyanatPaisa: loaded.report.shakhaAyanatPaisa,
        suhridAyanatTaka: loaded.report.suhridAyanatTaka,
        suhridAyanatPaisa: loaded.report.suhridAyanatPaisa,
        ekkalinIncomeTaka: loaded.report.ekkalinIncomeTaka,
        ekkalinIncomePaisa: loaded.report.ekkalinIncomePaisa,
        customIncomeRows: loaded.report.customIncomeRows,
        incomeInWords: loaded.report.incomeInWords,
        previousSurplusTaka: loaded.report.previousSurplusTaka,
        previousSurplusPaisa: loaded.report.previousSurplusPaisa,
        upwardAyanatTaka: loaded.report.upwardAyanatTaka,
        upwardAyanatPaisa: loaded.report.upwardAyanatPaisa,
        upwardSafarTaka: loaded.report.upwardSafarTaka,
        upwardSafarPaisa: loaded.report.upwardSafarPaisa,
        officeTaka: loaded.report.officeTaka,
        officePaisa: loaded.report.officePaisa,
        transportTaka: loaded.report.transportTaka,
        transportPaisa: loaded.report.transportPaisa,
        communicationTaka: loaded.report.communicationTaka,
        communicationPaisa: loaded.report.communicationPaisa,
        procharTaka: loaded.report.procharTaka,
        procharPaisa: loaded.report.procharPaisa,
        customExpenseRows: updatedList,
        expenseInWords: loaded.report.expenseInWords,
        previousDeficitTaka: loaded.report.previousDeficitTaka,
        previousDeficitPaisa: loaded.report.previousDeficitPaisa,
      );

      emit(loaded.copyWith(report: updatedReport));
    }
  }

  void _onRemoveExpenseRow(
    RemoveCustomExpenseRowEvent event,
    Emitter<StudentBaytulmalReportState> emit,
  ) {
    if (state is StudentBaytulmalReportLoaded) {
      final loaded = state as StudentBaytulmalReportLoaded;
      final updatedList = List<StudentBaytulmalRowItem>.from(loaded.report.customExpenseRows);
      if (event.index >= 0 && event.index < updatedList.length) {
        updatedList.removeAt(event.index);
      }

      final updatedReport = StudentBaytulmalReportEntity(
        id: loaded.report.id,
        year: loaded.report.year,
        month: loaded.report.month,
        session: loaded.report.session,
        branchName: loaded.report.branchName,
        jonoshaktiAyanatTaka: loaded.report.jonoshaktiAyanatTaka,
        jonoshaktiAyanatPaisa: loaded.report.jonoshaktiAyanatPaisa,
        shakhaAyanatTaka: loaded.report.shakhaAyanatTaka,
        shakhaAyanatPaisa: loaded.report.shakhaAyanatPaisa,
        suhridAyanatTaka: loaded.report.suhridAyanatTaka,
        suhridAyanatPaisa: loaded.report.suhridAyanatPaisa,
        ekkalinIncomeTaka: loaded.report.ekkalinIncomeTaka,
        ekkalinIncomePaisa: loaded.report.ekkalinIncomePaisa,
        customIncomeRows: loaded.report.customIncomeRows,
        incomeInWords: loaded.report.incomeInWords,
        previousSurplusTaka: loaded.report.previousSurplusTaka,
        previousSurplusPaisa: loaded.report.previousSurplusPaisa,
        upwardAyanatTaka: loaded.report.upwardAyanatTaka,
        upwardAyanatPaisa: loaded.report.upwardAyanatPaisa,
        upwardSafarTaka: loaded.report.upwardSafarTaka,
        upwardSafarPaisa: loaded.report.upwardSafarPaisa,
        officeTaka: loaded.report.officeTaka,
        officePaisa: loaded.report.officePaisa,
        transportTaka: loaded.report.transportTaka,
        transportPaisa: loaded.report.transportPaisa,
        communicationTaka: loaded.report.communicationTaka,
        communicationPaisa: loaded.report.communicationPaisa,
        procharTaka: loaded.report.procharTaka,
        procharPaisa: loaded.report.procharPaisa,
        customExpenseRows: updatedList,
        expenseInWords: loaded.report.expenseInWords,
        previousDeficitTaka: loaded.report.previousDeficitTaka,
        previousDeficitPaisa: loaded.report.previousDeficitPaisa,
      );

      emit(loaded.copyWith(report: updatedReport));
    }
  }

  void _onToggleLock(
    ToggleLockStatusEvent event,
    Emitter<StudentBaytulmalReportState> emit,
  ) {
    if (state is StudentBaytulmalReportLoaded) {
      final loaded = state as StudentBaytulmalReportLoaded;
      emit(loaded.copyWith(isLocked: !loaded.isLocked));
    }
  }
}

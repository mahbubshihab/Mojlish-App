import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/branch_report_repository.dart';
import 'branch_report_event.dart';
import 'branch_report_state.dart';

class BranchReportBloc extends Bloc<BranchReportEvent, BranchReportState> {
  final BranchReportRepository repository;

  BranchReportBloc({required this.repository}) : super(BranchReportInitial()) {
    on<SubmitBranchReportEvent>(_onSubmitReport);
    on<LoadBranchReportsEvent>(_onLoadReports);
  }

  Future<void> _onSubmitReport(
    SubmitBranchReportEvent event,
    Emitter<BranchReportState> emit,
  ) async {
    emit(BranchReportLoading());
    final result = await repository.submitReport(event.report);
    result.fold(
      (failure) => emit(BranchReportError(failure.toString())),
      (report) => emit(BranchReportSubmitted(report)),
    );
  }

  Future<void> _onLoadReports(
    LoadBranchReportsEvent event,
    Emitter<BranchReportState> emit,
  ) async {
    emit(BranchReportLoading());
    final result = await repository.getReports();
    result.fold(
      (failure) => emit(BranchReportError(failure.toString())),
      (reports) => emit(BranchReportLoaded(reports)),
    );
  }
}

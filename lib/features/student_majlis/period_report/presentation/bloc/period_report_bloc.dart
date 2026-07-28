import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/period_report_repository.dart';
import 'period_report_event.dart';
import 'period_report_state.dart';

class PeriodReportBloc extends Bloc<PeriodReportEvent, PeriodReportState> {
  final PeriodReportRepository repository;

  PeriodReportBloc({required this.repository}) : super(PeriodReportInitial()) {
    on<SubmitPeriodReportEvent>(_onSubmitPeriodReportEvent);
  }

  Future<void> _onSubmitPeriodReportEvent(
      SubmitPeriodReportEvent event, Emitter<PeriodReportState> emit) async {
    emit(PeriodReportLoading());
    try {
      await repository.submitPeriodReport(event.report);
      emit(PeriodReportSuccess());
    } catch (e) {
      emit(PeriodReportFailure(message: e.toString()));
    }
  }
}

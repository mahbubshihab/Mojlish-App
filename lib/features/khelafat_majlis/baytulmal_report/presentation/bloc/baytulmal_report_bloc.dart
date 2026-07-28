import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/baytulmal_report_repository.dart';
import 'baytulmal_report_event.dart';
import 'baytulmal_report_state.dart';

class BaytulmalReportBloc extends Bloc<BaytulmalReportEvent, BaytulmalReportState> {
  final BaytulmalReportRepository repository;

  BaytulmalReportBloc({required this.repository}) : super(BaytulmalReportInitial()) {
    on<SubmitBaytulmalReportEvent>(_onSubmitBaytulmalReportEvent);
  }

  Future<void> _onSubmitBaytulmalReportEvent(
      SubmitBaytulmalReportEvent event, Emitter<BaytulmalReportState> emit) async {
    emit(BaytulmalReportLoading());
    try {
      await repository.submitReport(event.report);
      emit(BaytulmalReportSuccess());
    } catch (e) {
      emit(BaytulmalReportFailure(message: e.toString()));
    }
  }
}

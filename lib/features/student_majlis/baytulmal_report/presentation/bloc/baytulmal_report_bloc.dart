import 'package:flutter_bloc/flutter_bloc.dart';
import 'baytulmal_report_event.dart';
import 'baytulmal_report_state.dart';
import '../../domain/repositories/baytulmal_report_repository.dart';
import '../../data/models/baytulmal_report_model.dart';

class BaytulmalReportBloc extends Bloc<BaytulmalReportEvent, BaytulmalReportState> {
  final BaytulmalReportRepository repository;

  BaytulmalReportBloc({required this.repository}) : super(BaytulmalReportInitial()) {
    on<SubmitBaytulmalReport>(_onSubmit);
  }

  void _onSubmit(SubmitBaytulmalReport event, Emitter<BaytulmalReportState> emit) async {
    emit(BaytulmalReportLoading());
    try {
      final model = BaytulmalReportModel.fromJson(event.reportData);
      await repository.submitReport(model);
      emit(BaytulmalReportSuccess());
    } catch (e) {
      emit(BaytulmalReportFailure(e.toString()));
    }
  }
}

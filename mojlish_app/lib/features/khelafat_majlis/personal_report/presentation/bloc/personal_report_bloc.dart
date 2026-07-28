import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/personal_report_repository.dart';
import 'personal_report_event.dart';
import 'personal_report_state.dart';

class PersonalReportBloc extends Bloc<PersonalReportEvent, PersonalReportState> {
  final PersonalReportRepository repository;

  PersonalReportBloc({required this.repository}) : super(PersonalReportInitial()) {
    on<LoadPersonalReportEvent>(_onLoadPersonalReport);
    on<SavePersonalReportEvent>(_onSavePersonalReport);
  }

  Future<void> _onLoadPersonalReport(
      LoadPersonalReportEvent event, Emitter<PersonalReportState> emit) async {
    emit(PersonalReportLoading());
    try {
      final report = await repository.getPersonalReport(event.month, event.year);
      if (report != null) {
        emit(PersonalReportLoaded(report: report));
      } else {
        emit(const PersonalReportError(message: 'Report not found'));
      }
    } catch (e) {
      emit(PersonalReportError(message: e.toString()));
    }
  }

  Future<void> _onSavePersonalReport(
      SavePersonalReportEvent event, Emitter<PersonalReportState> emit) async {
    emit(PersonalReportLoading());
    try {
      await repository.savePersonalReport(event.report);
      emit(PersonalReportSaved());
    } catch (e) {
      emit(PersonalReportError(message: e.toString()));
    }
  }
}

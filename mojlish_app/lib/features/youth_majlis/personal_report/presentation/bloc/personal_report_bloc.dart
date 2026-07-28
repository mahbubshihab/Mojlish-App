import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/personal_report_repository.dart';
import 'personal_report_event.dart';
import 'personal_report_state.dart';

class YouthMajlisPersonalReportBloc
    extends Bloc<YouthMajlisPersonalReportEvent, YouthMajlisPersonalReportState> {
  final YouthMajlisPersonalReportRepository repository;

  YouthMajlisPersonalReportBloc({required this.repository}) : super(PersonalReportInitial()) {
    on<SavePersonalReportEvent>(_onSavePersonalReport);
    on<LoadPersonalReportEvent>(_onLoadPersonalReport);
  }

  Future<void> _onSavePersonalReport(
      SavePersonalReportEvent event, Emitter<YouthMajlisPersonalReportState> emit) async {
    emit(PersonalReportLoading());
    final result = await repository.savePersonalReport(event.report);
    result.fold(
      (failure) => emit(const PersonalReportError(message: 'Failed to save personal report')),
      (_) => emit(PersonalReportSaved()),
    );
  }

  Future<void> _onLoadPersonalReport(
      LoadPersonalReportEvent event, Emitter<YouthMajlisPersonalReportState> emit) async {
    emit(PersonalReportLoading());
    final result = await repository.getPersonalReport(event.id);
    result.fold(
      (failure) => emit(const PersonalReportError(message: 'Failed to load personal report')),
      (report) => emit(PersonalReportLoaded(report: report)),
    );
  }
}

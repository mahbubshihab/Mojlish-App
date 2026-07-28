import 'package:flutter_bloc/flutter_bloc.dart';
import 'women_majlis_personal_report_event.dart';
import 'women_majlis_personal_report_state.dart';
import '../../domain/repositories/women_majlis_personal_report_repository.dart';

class WomenMajlisPersonalReportBloc extends Bloc<WomenMajlisPersonalReportEvent, WomenMajlisPersonalReportState> {
  final WomenMajlisPersonalReportRepository repository;

  WomenMajlisPersonalReportBloc({required this.repository}) : super(WomenMajlisPersonalReportInitial()) {
    on<LoadWomenMajlisPersonalReport>(_onLoadPersonalReport);
    on<SaveWomenMajlisPersonalReport>(_onSavePersonalReport);
  }

  Future<void> _onLoadPersonalReport(
    LoadWomenMajlisPersonalReport event,
    Emitter<WomenMajlisPersonalReportState> emit,
  ) async {
    emit(WomenMajlisPersonalReportLoading());
    final result = await repository.getPersonalReport();
    result.fold(
      (failure) => emit(const WomenMajlisPersonalReportError('Failed to load report')),
      (report) => emit(WomenMajlisPersonalReportLoaded(report)),
    );
  }

  Future<void> _onSavePersonalReport(
    SaveWomenMajlisPersonalReport event,
    Emitter<WomenMajlisPersonalReportState> emit,
  ) async {
    emit(WomenMajlisPersonalReportLoading());
    final result = await repository.savePersonalReport(event.report);
    result.fold(
      (failure) => emit(const WomenMajlisPersonalReportError('Failed to save report')),
      (success) => emit(WomenMajlisPersonalReportSaved()),
    );
  }
}

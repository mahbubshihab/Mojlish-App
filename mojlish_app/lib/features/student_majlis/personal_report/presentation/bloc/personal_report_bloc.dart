import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mojlish_app/features/student_majlis/personal_report/domain/repositories/personal_report_repository.dart';
import 'package:mojlish_app/features/student_majlis/personal_report/presentation/bloc/personal_report_event.dart';
import 'package:mojlish_app/features/student_majlis/personal_report/presentation/bloc/personal_report_state.dart';

class PersonalReportBloc extends Bloc<PersonalReportEvent, PersonalReportState> {
  final PersonalReportRepository repository;

  PersonalReportBloc({required this.repository}) : super(PersonalReportInitial()) {
    on<LoadPersonalReport>(_onLoadPersonalReport);
    on<SubmitPersonalReport>(_onSubmitPersonalReport);
  }

  Future<void> _onLoadPersonalReport(
      LoadPersonalReport event, Emitter<PersonalReportState> emit) async {
    emit(PersonalReportLoading());
    final result = await repository.getPersonalReport(event.month, event.year);
    result.fold(
      (failure) => emit(const PersonalReportError(message: 'Failed to load report')),
      (report) => emit(PersonalReportLoaded(report: report)),
    );
  }

  Future<void> _onSubmitPersonalReport(
      SubmitPersonalReport event, Emitter<PersonalReportState> emit) async {
    emit(PersonalReportLoading());
    final result = await repository.submitPersonalReport(event.report);
    result.fold(
      (failure) => emit(const PersonalReportError(message: 'Failed to submit report')),
      (_) => emit(PersonalReportSubmitSuccess()),
    );
  }
}

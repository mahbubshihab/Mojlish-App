import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/khelafot_syllabus_repository.dart';
import 'khelafot_syllabus_event.dart';
import 'khelafot_syllabus_state.dart';

class KhelafotSyllabusBloc extends Bloc<KhelafotSyllabusEvent, KhelafotSyllabusState> {
  final KhelafotSyllabusRepository repository;

  KhelafotSyllabusBloc({required this.repository}) : super(KhelafotSyllabusInitial()) {
    on<GetKhelafotSyllabiEvent>((event, emit) async {
      emit(KhelafotSyllabusLoading());
      final failureOrSyllabi = await repository.getSyllabi();
      failureOrSyllabi.fold(
        (failure) => emit(const KhelafotSyllabusError(message: 'Server Failure')),
        (syllabi) => emit(KhelafotSyllabusLoaded(syllabi: syllabi)),
      );
    });
  }
}

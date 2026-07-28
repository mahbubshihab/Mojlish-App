import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/khelafot_syllabus_repository.dart';
import '../../data/datasources/khelafot_syllabus_remote_datasource.dart';
import 'khelafot_syllabus_event.dart';
import 'khelafot_syllabus_state.dart';

class KhelafotSyllabusBloc extends Bloc<KhelafotSyllabusEvent, KhelafotSyllabusState> {
  final KhelafotSyllabusRepository repository;

  KhelafotSyllabusBloc({required this.repository}) : super(KhelafotSyllabusInitial()) {
    on<GetKhelafotSyllabiEvent>(_onGetKhelafotSyllabi);
    on<ToggleBookCompletionEvent>(_onToggleBookCompletion);
    on<FilterSyllabusEvent>(_onFilterSyllabus);
  }

  Future<void> _onGetKhelafotSyllabi(
    GetKhelafotSyllabiEvent event,
    Emitter<KhelafotSyllabusState> emit,
  ) async {
    emit(KhelafotSyllabusLoading());
    final result = await repository.getSyllabi();
    await result.fold(
      (failure) async => emit(const KhelafotSyllabusError(message: 'সিলেবাস তথ্য লোড করতে ব্যর্থ হয়েছে')),
      (syllabi) async {
        final dataSource = KhelafotSyllabusRemoteDataSourceImpl();
        final fullData = await dataSource.getFullSyllabusData();
        emit(KhelafotSyllabusLoaded(
          syllabi: syllabi,
          fullData: fullData,
        ));
      },
    );
  }

  void _onToggleBookCompletion(
    ToggleBookCompletionEvent event,
    Emitter<KhelafotSyllabusState> emit,
  ) {
    if (state is KhelafotSyllabusLoaded) {
      final current = state as KhelafotSyllabusLoaded;
      final updatedSet = Set<String>.from(current.completedBookIds);
      if (updatedSet.contains(event.bookId)) {
        updatedSet.remove(event.bookId);
      } else {
        updatedSet.add(event.bookId);
      }
      emit(current.copyWith(completedBookIds: updatedSet));
    }
  }

  void _onFilterSyllabus(
    FilterSyllabusEvent event,
    Emitter<KhelafotSyllabusState> emit,
  ) {
    if (state is KhelafotSyllabusLoaded) {
      final current = state as KhelafotSyllabusLoaded;
      emit(current.copyWith(
        searchQuery: event.query,
        bookFilter: event.bookFilter ?? current.bookFilter,
      ));
    }
  }
}

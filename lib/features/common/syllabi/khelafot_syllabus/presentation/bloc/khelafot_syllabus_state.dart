import 'package:equatable/equatable.dart';
import '../../domain/entities/khelafot_syllabus_entity.dart';

abstract class KhelafotSyllabusState extends Equatable {
  const KhelafotSyllabusState();
  
  @override
  List<Object?> get props => [];
}

class KhelafotSyllabusInitial extends KhelafotSyllabusState {}

class KhelafotSyllabusLoading extends KhelafotSyllabusState {}

class KhelafotSyllabusLoaded extends KhelafotSyllabusState {
  final List<KhelafotSyllabusEntity> syllabi;
  final KhelafotSyllabusData fullData;
  final Set<String> completedBookIds;
  final String searchQuery;
  final String bookFilter; // 'all', 'mandatory', 'optional'

  const KhelafotSyllabusLoaded({
    required this.syllabi,
    required this.fullData,
    this.completedBookIds = const {},
    this.searchQuery = '',
    this.bookFilter = 'all',
  });

  int get totalBooks {
    int count = 0;
    for (final level in fullData.levels) {
      for (final cat in level.categories) {
        count += cat.books.length;
      }
    }
    return count;
  }

  int get completedBooksCount {
    return completedBookIds.length;
  }

  double get overallProgress {
    if (totalBooks == 0) return 0.0;
    return completedBooksCount / totalBooks;
  }

  KhelafotSyllabusLoaded copyWith({
    List<KhelafotSyllabusEntity>? syllabi,
    KhelafotSyllabusData? fullData,
    Set<String>? completedBookIds,
    String? searchQuery,
    String? bookFilter,
  }) {
    return KhelafotSyllabusLoaded(
      syllabi: syllabi ?? this.syllabi,
      fullData: fullData ?? this.fullData,
      completedBookIds: completedBookIds ?? this.completedBookIds,
      searchQuery: searchQuery ?? this.searchQuery,
      bookFilter: bookFilter ?? this.bookFilter,
    );
  }

  @override
  List<Object?> get props => [syllabi, fullData, completedBookIds, searchQuery, bookFilter];
}

class KhelafotSyllabusError extends KhelafotSyllabusState {
  final String message;

  const KhelafotSyllabusError({required this.message});

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';

abstract class KhelafotSyllabusEvent extends Equatable {
  const KhelafotSyllabusEvent();

  @override
  List<Object?> get props => [];
}

class GetKhelafotSyllabiEvent extends KhelafotSyllabusEvent {}

class ToggleBookCompletionEvent extends KhelafotSyllabusEvent {
  final String bookId;

  const ToggleBookCompletionEvent({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}

class FilterSyllabusEvent extends KhelafotSyllabusEvent {
  final String query;
  final String? bookFilter; // null or 'all', 'mandatory', 'optional'

  const FilterSyllabusEvent({required this.query, this.bookFilter});

  @override
  List<Object?> get props => [query, bookFilter];
}

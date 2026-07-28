import 'package:equatable/equatable.dart';
import '../../domain/entities/khelafot_syllabus_entity.dart';

abstract class KhelafotSyllabusState extends Equatable {
  const KhelafotSyllabusState();
  
  @override
  List<Object> get props => [];
}

class KhelafotSyllabusInitial extends KhelafotSyllabusState {}

class KhelafotSyllabusLoading extends KhelafotSyllabusState {}

class KhelafotSyllabusLoaded extends KhelafotSyllabusState {
  final List<KhelafotSyllabusEntity> syllabi;

  const KhelafotSyllabusLoaded({required this.syllabi});

  @override
  List<Object> get props => [syllabi];
}

class KhelafotSyllabusError extends KhelafotSyllabusState {
  final String message;

  const KhelafotSyllabusError({required this.message});

  @override
  List<Object> get props => [message];
}

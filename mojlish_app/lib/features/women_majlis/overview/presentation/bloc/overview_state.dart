import 'package:equatable/equatable.dart';
import '../../domain/entities/overview_entity.dart';

abstract class OverviewState extends Equatable {
  const OverviewState();

  @override
  List<Object> get props => [];
}

class OverviewInitial extends OverviewState {}

class OverviewLoading extends OverviewState {}

class OverviewLoaded extends OverviewState {
  final OverviewEntity overview;

  const OverviewLoaded({required this.overview});

  @override
  List<Object> get props => [overview];
}

class OverviewError extends OverviewState {
  final String message;

  const OverviewError({required this.message});

  @override
  List<Object> get props => [message];
}

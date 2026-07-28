import 'package:equatable/equatable.dart';

abstract class WomenOverviewState extends Equatable {
  const WomenOverviewState();
  @override
  List<Object?> get props => [];
}

class WomenOverviewInitial extends WomenOverviewState {}
class WomenOverviewLoading extends WomenOverviewState {}
class WomenOverviewLoaded extends WomenOverviewState {}

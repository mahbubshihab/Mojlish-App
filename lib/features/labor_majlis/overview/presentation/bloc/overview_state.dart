import 'package:equatable/equatable.dart';

abstract class LaborOverviewState extends Equatable {
  const LaborOverviewState();
  @override
  List<Object?> get props => [];
}

class LaborOverviewInitial extends LaborOverviewState {}
class LaborOverviewLoading extends LaborOverviewState {}
class LaborOverviewLoaded extends LaborOverviewState {}

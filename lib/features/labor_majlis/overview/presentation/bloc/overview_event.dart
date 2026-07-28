import 'package:equatable/equatable.dart';

abstract class LaborOverviewEvent extends Equatable {
  const LaborOverviewEvent();
  @override
  List<Object?> get props => [];
}

class LoadLaborOverviewData extends LaborOverviewEvent {}

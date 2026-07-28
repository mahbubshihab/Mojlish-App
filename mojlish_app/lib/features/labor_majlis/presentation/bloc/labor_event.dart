import 'package:equatable/equatable.dart';

abstract class LaborEvent extends Equatable {
  const LaborEvent();

  @override
  List<Object?> get props => [];
}

class LoadLaborData extends LaborEvent {}

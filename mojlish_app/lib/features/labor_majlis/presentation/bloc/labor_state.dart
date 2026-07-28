import 'package:equatable/equatable.dart';

abstract class LaborState extends Equatable {
  const LaborState();

  @override
  List<Object?> get props => [];
}

class LaborInitial extends LaborState {}
class LaborLoading extends LaborState {}
class LaborLoaded extends LaborState {}

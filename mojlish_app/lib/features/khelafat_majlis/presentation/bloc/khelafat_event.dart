import 'package:equatable/equatable.dart';

abstract class KhelafatEvent extends Equatable {
  const KhelafatEvent();

  @override
  List<Object?> get props => [];
}

class LoadKhelafatData extends KhelafatEvent {}

import 'package:equatable/equatable.dart';

abstract class YouthEvent extends Equatable {
  const YouthEvent();

  @override
  List<Object?> get props => [];
}

class LoadYouthData extends YouthEvent {}

import 'package:equatable/equatable.dart';

abstract class WomenEvent extends Equatable {
  const WomenEvent();

  @override
  List<Object?> get props => [];
}

class LoadWomenData extends WomenEvent {}

import 'package:equatable/equatable.dart';

abstract class WomenOverviewEvent extends Equatable {
  const WomenOverviewEvent();
  @override
  List<Object?> get props => [];
}

class LoadWomenOverviewData extends WomenOverviewEvent {}

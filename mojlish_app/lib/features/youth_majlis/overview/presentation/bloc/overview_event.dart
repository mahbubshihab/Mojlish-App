import 'package:equatable/equatable.dart';

abstract class YouthOverviewEvent extends Equatable {
  const YouthOverviewEvent();
  @override
  List<Object?> get props => [];
}

class LoadYouthOverviewData extends YouthOverviewEvent {}

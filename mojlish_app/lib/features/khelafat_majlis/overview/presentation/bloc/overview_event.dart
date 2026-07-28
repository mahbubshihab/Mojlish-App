import 'package:equatable/equatable.dart';

abstract class KhelafatOverviewEvent extends Equatable {
  const KhelafatOverviewEvent();
  @override
  List<Object?> get props => [];
}

class LoadKhelafatOverviewData extends KhelafatOverviewEvent {}

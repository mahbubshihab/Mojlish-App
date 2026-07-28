import 'package:equatable/equatable.dart';

abstract class KhelafatOverviewState extends Equatable {
  const KhelafatOverviewState();
  @override
  List<Object?> get props => [];
}

class KhelafatOverviewInitial extends KhelafatOverviewState {}
class KhelafatOverviewLoading extends KhelafatOverviewState {}
class KhelafatOverviewLoaded extends KhelafatOverviewState {}

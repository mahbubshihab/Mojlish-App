import 'package:equatable/equatable.dart';

abstract class YouthOverviewState extends Equatable {
  const YouthOverviewState();
  @override
  List<Object?> get props => [];
}

class YouthOverviewInitial extends YouthOverviewState {}
class YouthOverviewLoading extends YouthOverviewState {}
class YouthOverviewLoaded extends YouthOverviewState {}

import 'package:equatable/equatable.dart';

abstract class PeriodReportState extends Equatable {
  const PeriodReportState();

  @override
  List<Object> get props => [];
}

class PeriodReportInitial extends PeriodReportState {}

class PeriodReportLoading extends PeriodReportState {}

class PeriodReportSuccess extends PeriodReportState {}

class PeriodReportFailure extends PeriodReportState {
  final String message;

  const PeriodReportFailure({required this.message});

  @override
  List<Object> get props => [message];
}

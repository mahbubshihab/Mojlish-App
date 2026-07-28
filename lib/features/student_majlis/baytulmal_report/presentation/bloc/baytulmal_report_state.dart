import 'package:equatable/equatable.dart';

abstract class BaytulmalReportState extends Equatable {
  const BaytulmalReportState();

  @override
  List<Object> get props => [];
}

class BaytulmalReportInitial extends BaytulmalReportState {}

class BaytulmalReportLoading extends BaytulmalReportState {}

class BaytulmalReportSuccess extends BaytulmalReportState {}

class BaytulmalReportFailure extends BaytulmalReportState {
  final String error;

  const BaytulmalReportFailure(this.error);

  @override
  List<Object> get props => [error];
}

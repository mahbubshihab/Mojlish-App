abstract class BaytulmalReportState {}

class BaytulmalReportInitial extends BaytulmalReportState {}

class BaytulmalReportLoading extends BaytulmalReportState {}

class BaytulmalReportSuccess extends BaytulmalReportState {}

class BaytulmalReportFailure extends BaytulmalReportState {
  final String message;

  BaytulmalReportFailure({required this.message});
}

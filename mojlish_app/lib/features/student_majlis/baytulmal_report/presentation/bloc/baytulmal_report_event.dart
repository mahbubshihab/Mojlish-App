import 'package:equatable/equatable.dart';

abstract class BaytulmalReportEvent extends Equatable {
  const BaytulmalReportEvent();

  @override
  List<Object> get props => [];
}

class SubmitBaytulmalReport extends BaytulmalReportEvent {
  final Map<String, dynamic> reportData;

  const SubmitBaytulmalReport(this.reportData);

  @override
  List<Object> get props => [reportData];
}

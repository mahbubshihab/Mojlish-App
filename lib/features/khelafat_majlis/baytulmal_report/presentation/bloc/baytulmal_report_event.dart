import '../../domain/entities/baytulmal_report_entity.dart';

abstract class BaytulmalReportEvent {}

class SubmitBaytulmalReportEvent extends BaytulmalReportEvent {
  final BaytulmalReportEntity report;

  SubmitBaytulmalReportEvent({required this.report});
}

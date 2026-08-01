import 'package:equatable/equatable.dart';
import '../../domain/entities/personal_report.dart';

abstract class YouthMajlisPersonalReportEvent extends Equatable {
  const YouthMajlisPersonalReportEvent();

  @override
  List<Object> get props => [];
}

class SavePersonalReportEvent extends YouthMajlisPersonalReportEvent {
  final YouthMajlisPersonalReport report;

  const SavePersonalReportEvent({required this.report});

  @override
  List<Object> get props => [report];
}

class LoadPersonalReportEvent extends YouthMajlisPersonalReportEvent {
  final String id;

  const LoadPersonalReportEvent({required this.id});

  @override
  List<Object> get props => [id];
}

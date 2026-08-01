import 'package:equatable/equatable.dart';
import '../../domain/entities/women_majlis_personal_report_entity.dart';

abstract class WomenMajlisPersonalReportEvent extends Equatable {
  const WomenMajlisPersonalReportEvent();

  @override
  List<Object?> get props => [];
}

class LoadWomenMajlisPersonalReport extends WomenMajlisPersonalReportEvent {}

class SaveWomenMajlisPersonalReport extends WomenMajlisPersonalReportEvent {
  final WomenMajlisPersonalReportEntity report;

  const SaveWomenMajlisPersonalReport(this.report);

  @override
  List<Object?> get props => [report];
}

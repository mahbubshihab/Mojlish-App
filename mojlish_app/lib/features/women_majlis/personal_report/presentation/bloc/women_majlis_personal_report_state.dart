import 'package:equatable/equatable.dart';
import '../../domain/entities/women_majlis_personal_report_entity.dart';

abstract class WomenMajlisPersonalReportState extends Equatable {
  const WomenMajlisPersonalReportState();

  @override
  List<Object?> get props => [];
}

class WomenMajlisPersonalReportInitial extends WomenMajlisPersonalReportState {}

class WomenMajlisPersonalReportLoading extends WomenMajlisPersonalReportState {}

class WomenMajlisPersonalReportLoaded extends WomenMajlisPersonalReportState {
  final WomenMajlisPersonalReportEntity report;

  const WomenMajlisPersonalReportLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class WomenMajlisPersonalReportError extends WomenMajlisPersonalReportState {
  final String message;

  const WomenMajlisPersonalReportError(this.message);

  @override
  List<Object?> get props => [message];
}

class WomenMajlisPersonalReportSaved extends WomenMajlisPersonalReportState {}

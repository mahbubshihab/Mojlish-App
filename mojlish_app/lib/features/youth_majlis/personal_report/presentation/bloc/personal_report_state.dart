import 'package:equatable/equatable.dart';
import 'package:mojlish_app/features/youth_majlis/personal_report/domain/entities/personal_report.dart';

abstract class YouthMajlisPersonalReportState extends Equatable {
  const YouthMajlisPersonalReportState();

  @override
  List<Object> get props => [];
}

class PersonalReportInitial extends YouthMajlisPersonalReportState {}

class PersonalReportLoading extends YouthMajlisPersonalReportState {}

class PersonalReportLoaded extends YouthMajlisPersonalReportState {
  final YouthMajlisPersonalReport report;

  const PersonalReportLoaded({required this.report});

  @override
  List<Object> get props => [report];
}

class PersonalReportSaved extends YouthMajlisPersonalReportState {}

class PersonalReportError extends YouthMajlisPersonalReportState {
  final String message;

  const PersonalReportError({required this.message});

  @override
  List<Object> get props => [message];
}

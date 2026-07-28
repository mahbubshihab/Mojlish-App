import 'package:equatable/equatable.dart';

abstract class YouthPersonalReportState extends Equatable {
  const YouthPersonalReportState();
  @override
  List<Object?> get props => [];
}

class YouthPersonalReportInitial extends YouthPersonalReportState {}
class YouthPersonalReportLoading extends YouthPersonalReportState {}
class YouthPersonalReportLoaded extends YouthPersonalReportState {}

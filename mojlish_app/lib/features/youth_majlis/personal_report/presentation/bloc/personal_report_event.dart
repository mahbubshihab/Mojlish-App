import 'package:equatable/equatable.dart';

abstract class YouthPersonalReportEvent extends Equatable {
  const YouthPersonalReportEvent();
  @override
  List<Object?> get props => [];
}

class LoadYouthPersonalReportData extends YouthPersonalReportEvent {}

import 'package:equatable/equatable.dart';

abstract class LaborPersonalReportEvent extends Equatable {
  const LaborPersonalReportEvent();
  @override
  List<Object?> get props => [];
}

class LoadLaborPersonalReportData extends LaborPersonalReportEvent {}

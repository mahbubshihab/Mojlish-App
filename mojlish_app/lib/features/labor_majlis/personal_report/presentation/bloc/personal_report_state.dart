import 'package:equatable/equatable.dart';

abstract class LaborPersonalReportState extends Equatable {
  const LaborPersonalReportState();
  @override
  List<Object?> get props => [];
}

class LaborPersonalReportInitial extends LaborPersonalReportState {}
class LaborPersonalReportLoading extends LaborPersonalReportState {}
class LaborPersonalReportLoaded extends LaborPersonalReportState {}

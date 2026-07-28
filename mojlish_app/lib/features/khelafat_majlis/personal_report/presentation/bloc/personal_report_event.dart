import 'package:equatable/equatable.dart';

abstract class KhelafatPersonalReportEvent extends Equatable {
  const KhelafatPersonalReportEvent();
  @override
  List<Object?> get props => [];
}

class LoadKhelafatPersonalReportData extends KhelafatPersonalReportEvent {}

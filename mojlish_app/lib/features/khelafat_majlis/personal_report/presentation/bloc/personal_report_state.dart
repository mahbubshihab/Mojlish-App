import 'package:equatable/equatable.dart';

abstract class KhelafatPersonalReportState extends Equatable {
  const KhelafatPersonalReportState();
  @override
  List<Object?> get props => [];
}

class KhelafatPersonalReportInitial extends KhelafatPersonalReportState {}
class KhelafatPersonalReportLoading extends KhelafatPersonalReportState {}
class KhelafatPersonalReportLoaded extends KhelafatPersonalReportState {}

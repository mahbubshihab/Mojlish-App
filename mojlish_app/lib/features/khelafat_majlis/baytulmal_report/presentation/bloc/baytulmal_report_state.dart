import 'package:equatable/equatable.dart';

abstract class KhelafatBaytulmalReportState extends Equatable {
  const KhelafatBaytulmalReportState();
  @override
  List<Object?> get props => [];
}

class KhelafatBaytulmalReportInitial extends KhelafatBaytulmalReportState {}
class KhelafatBaytulmalReportLoading extends KhelafatBaytulmalReportState {}
class KhelafatBaytulmalReportLoaded extends KhelafatBaytulmalReportState {}

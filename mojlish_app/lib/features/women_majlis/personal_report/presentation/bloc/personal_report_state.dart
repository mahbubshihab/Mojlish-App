import 'package:equatable/equatable.dart';

abstract class WomenPersonalReportState extends Equatable {
  const WomenPersonalReportState();
  @override
  List<Object?> get props => [];
}

class WomenPersonalReportInitial extends WomenPersonalReportState {}
class WomenPersonalReportLoading extends WomenPersonalReportState {}
class WomenPersonalReportLoaded extends WomenPersonalReportState {}

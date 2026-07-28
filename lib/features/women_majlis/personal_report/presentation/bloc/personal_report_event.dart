import 'package:equatable/equatable.dart';

abstract class WomenPersonalReportEvent extends Equatable {
  const WomenPersonalReportEvent();
  @override
  List<Object?> get props => [];
}

class LoadWomenPersonalReportData extends WomenPersonalReportEvent {}

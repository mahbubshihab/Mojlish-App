import 'package:equatable/equatable.dart';

abstract class StudentPersonalReportState extends Equatable {
  const StudentPersonalReportState();
  @override
  List<Object?> get props => [];
}

class StudentPersonalReportInitial extends StudentPersonalReportState {}
class StudentPersonalReportLoading extends StudentPersonalReportState {}
class StudentPersonalReportLoaded extends StudentPersonalReportState {}

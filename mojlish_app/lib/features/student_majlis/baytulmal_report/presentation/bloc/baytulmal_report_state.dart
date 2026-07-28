import 'package:equatable/equatable.dart';

abstract class StudentBaytulmalReportState extends Equatable {
  const StudentBaytulmalReportState();
  @override
  List<Object?> get props => [];
}

class StudentBaytulmalReportInitial extends StudentBaytulmalReportState {}
class StudentBaytulmalReportLoading extends StudentBaytulmalReportState {}
class StudentBaytulmalReportLoaded extends StudentBaytulmalReportState {}

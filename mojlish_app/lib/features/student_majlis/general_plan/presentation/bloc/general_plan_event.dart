import 'package:equatable/equatable.dart';

abstract class StudentGeneralPlanEvent extends Equatable {
  const StudentGeneralPlanEvent();
  @override
  List<Object?> get props => [];
}

class LoadStudentGeneralPlanData extends StudentGeneralPlanEvent {}

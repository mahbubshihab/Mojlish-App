import 'package:equatable/equatable.dart';

abstract class StudentPersonalPlanEvent extends Equatable {
  const StudentPersonalPlanEvent();
  @override
  List<Object?> get props => [];
}

class LoadStudentPersonalPlanData extends StudentPersonalPlanEvent {}

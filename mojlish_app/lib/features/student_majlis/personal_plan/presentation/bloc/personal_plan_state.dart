import 'package:equatable/equatable.dart';

abstract class StudentPersonalPlanState extends Equatable {
  const StudentPersonalPlanState();
  @override
  List<Object?> get props => [];
}

class StudentPersonalPlanInitial extends StudentPersonalPlanState {}
class StudentPersonalPlanLoading extends StudentPersonalPlanState {}
class StudentPersonalPlanLoaded extends StudentPersonalPlanState {}

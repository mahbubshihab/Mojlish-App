import 'package:equatable/equatable.dart';

abstract class StudentGeneralPlanState extends Equatable {
  const StudentGeneralPlanState();
  @override
  List<Object?> get props => [];
}

class StudentGeneralPlanInitial extends StudentGeneralPlanState {}
class StudentGeneralPlanLoading extends StudentGeneralPlanState {}
class StudentGeneralPlanLoaded extends StudentGeneralPlanState {}

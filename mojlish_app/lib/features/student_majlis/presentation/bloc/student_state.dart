import 'package:equatable/equatable.dart';

abstract class StudentState extends Equatable {
  const StudentState();

  @override
  List<Object?> get props => [];
}

class StudentInitial extends StudentState {}
class StudentLoading extends StudentState {}
class StudentLoaded extends StudentState {}

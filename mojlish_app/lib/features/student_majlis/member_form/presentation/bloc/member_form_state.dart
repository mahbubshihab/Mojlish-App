import 'package:equatable/equatable.dart';

abstract class StudentMemberFormState extends Equatable {
  const StudentMemberFormState();
  @override
  List<Object?> get props => [];
}

class StudentMemberFormInitial extends StudentMemberFormState {}
class StudentMemberFormLoading extends StudentMemberFormState {}
class StudentMemberFormLoaded extends StudentMemberFormState {}

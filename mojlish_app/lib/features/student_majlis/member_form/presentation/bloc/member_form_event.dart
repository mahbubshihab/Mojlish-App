import 'package:equatable/equatable.dart';

abstract class StudentMemberFormEvent extends Equatable {
  const StudentMemberFormEvent();
  @override
  List<Object?> get props => [];
}

class LoadStudentMemberFormData extends StudentMemberFormEvent {}

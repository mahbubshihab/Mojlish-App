import 'package:equatable/equatable.dart';

abstract class MemberFormState extends Equatable {
  const MemberFormState();
  
  @override
  List<Object> get props => [];
}

class MemberFormInitial extends MemberFormState {}

class MemberFormLoading extends MemberFormState {}

class MemberFormSuccess extends MemberFormState {}

class MemberFormError extends MemberFormState {
  final String message;

  const MemberFormError(this.message);

  @override
  List<Object> get props => [message];
}

import 'package:equatable/equatable.dart';

abstract class MemberFormState extends Equatable {
  const MemberFormState();

  @override
  List<Object?> get props => [];
}

class MemberFormInitial extends MemberFormState {}

class MemberFormLoading extends MemberFormState {}

class MemberFormSuccess extends MemberFormState {}

class MemberFormFailure extends MemberFormState {
  final String errorMessage;

  const MemberFormFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

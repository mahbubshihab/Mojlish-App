import 'package:equatable/equatable.dart';

abstract class LaborMemberFormState extends Equatable {
  const LaborMemberFormState();
  @override
  List<Object?> get props => [];
}

class LaborMemberFormInitial extends LaborMemberFormState {}
class LaborMemberFormLoading extends LaborMemberFormState {}
class LaborMemberFormLoaded extends LaborMemberFormState {}

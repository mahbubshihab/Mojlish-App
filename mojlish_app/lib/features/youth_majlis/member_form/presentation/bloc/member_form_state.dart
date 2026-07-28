import 'package:equatable/equatable.dart';

abstract class YouthMemberFormState extends Equatable {
  const YouthMemberFormState();
  @override
  List<Object?> get props => [];
}

class YouthMemberFormInitial extends YouthMemberFormState {}
class YouthMemberFormLoading extends YouthMemberFormState {}
class YouthMemberFormLoaded extends YouthMemberFormState {}

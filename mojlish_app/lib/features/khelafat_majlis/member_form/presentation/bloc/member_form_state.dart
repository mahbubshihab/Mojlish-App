import 'package:equatable/equatable.dart';

abstract class KhelafatMemberFormState extends Equatable {
  const KhelafatMemberFormState();
  @override
  List<Object?> get props => [];
}

class KhelafatMemberFormInitial extends KhelafatMemberFormState {}
class KhelafatMemberFormLoading extends KhelafatMemberFormState {}
class KhelafatMemberFormLoaded extends KhelafatMemberFormState {}

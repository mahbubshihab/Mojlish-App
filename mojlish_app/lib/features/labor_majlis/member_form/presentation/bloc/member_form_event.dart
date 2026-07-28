import 'package:equatable/equatable.dart';

abstract class LaborMemberFormEvent extends Equatable {
  const LaborMemberFormEvent();
  @override
  List<Object?> get props => [];
}

class LoadLaborMemberFormData extends LaborMemberFormEvent {}

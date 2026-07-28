import 'package:equatable/equatable.dart';

abstract class YouthMemberFormEvent extends Equatable {
  const YouthMemberFormEvent();
  @override
  List<Object?> get props => [];
}

class LoadYouthMemberFormData extends YouthMemberFormEvent {}

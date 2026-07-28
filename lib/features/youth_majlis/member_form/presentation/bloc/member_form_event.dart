import 'package:equatable/equatable.dart';
import '../../../domain/entities/member_form_entity.dart';

abstract class MemberFormEvent extends Equatable {
  const MemberFormEvent();

  @override
  List<Object?> get props => [];
}

class SubmitMemberForm extends MemberFormEvent {
  final MemberFormEntity entity;

  const SubmitMemberForm({required this.entity});

  @override
  List<Object?> get props => [entity];
}

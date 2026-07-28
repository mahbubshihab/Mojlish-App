import 'package:equatable/equatable.dart';
import '../../domain/entities/member.dart';

abstract class MemberFormEvent extends Equatable {
  const MemberFormEvent();

  @override
  List<Object> get props => [];
}

class SubmitMemberForm extends MemberFormEvent {
  final KhelafatMajlisMember member;

  const SubmitMemberForm(this.member);

  @override
  List<Object> get props => [member];
}

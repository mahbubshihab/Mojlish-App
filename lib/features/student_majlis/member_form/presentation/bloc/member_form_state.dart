abstract class MemberFormState {}

class MemberFormInitial extends MemberFormState {}
class MemberFormLoading extends MemberFormState {}
class MemberFormSuccess extends MemberFormState {}
class MemberFormError extends MemberFormState {
  final String message;
  MemberFormError(this.message);
}

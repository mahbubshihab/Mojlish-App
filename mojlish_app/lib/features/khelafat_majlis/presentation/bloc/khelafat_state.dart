import 'package:equatable/equatable.dart';

abstract class KhelafatState extends Equatable {
  const KhelafatState();

  @override
  List<Object?> get props => [];
}

class KhelafatInitial extends KhelafatState {}
class KhelafatLoading extends KhelafatState {}
class KhelafatLoaded extends KhelafatState {}

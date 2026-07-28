import 'package:equatable/equatable.dart';

abstract class KhelafatExecutiveRulesState extends Equatable {
  const KhelafatExecutiveRulesState();
  @override
  List<Object?> get props => [];
}

class KhelafatExecutiveRulesInitial extends KhelafatExecutiveRulesState {}
class KhelafatExecutiveRulesLoading extends KhelafatExecutiveRulesState {}
class KhelafatExecutiveRulesLoaded extends KhelafatExecutiveRulesState {}

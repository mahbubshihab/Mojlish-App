import 'package:equatable/equatable.dart';

abstract class WomenState extends Equatable {
  const WomenState();

  @override
  List<Object?> get props => [];
}

class WomenInitial extends WomenState {}
class WomenLoading extends WomenState {}
class WomenLoaded extends WomenState {}

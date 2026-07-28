import 'package:equatable/equatable.dart';

abstract class YouthState extends Equatable {
  const YouthState();

  @override
  List<Object?> get props => [];
}

class YouthInitial extends YouthState {}
class YouthLoading extends YouthState {}
class YouthLoaded extends YouthState {}

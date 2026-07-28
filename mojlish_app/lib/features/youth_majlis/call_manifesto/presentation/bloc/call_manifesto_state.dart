import 'package:equatable/equatable.dart';

abstract class YouthCallManifestoState extends Equatable {
  const YouthCallManifestoState();
  @override
  List<Object?> get props => [];
}

class YouthCallManifestoInitial extends YouthCallManifestoState {}
class YouthCallManifestoLoading extends YouthCallManifestoState {}
class YouthCallManifestoLoaded extends YouthCallManifestoState {}

import 'package:equatable/equatable.dart';

abstract class WomenCallManifestoState extends Equatable {
  const WomenCallManifestoState();
  @override
  List<Object?> get props => [];
}

class WomenCallManifestoInitial extends WomenCallManifestoState {}
class WomenCallManifestoLoading extends WomenCallManifestoState {}
class WomenCallManifestoLoaded extends WomenCallManifestoState {}

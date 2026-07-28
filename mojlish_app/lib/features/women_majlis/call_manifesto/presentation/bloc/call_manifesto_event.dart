import 'package:equatable/equatable.dart';

abstract class WomenCallManifestoEvent extends Equatable {
  const WomenCallManifestoEvent();
  @override
  List<Object?> get props => [];
}

class LoadWomenCallManifestoData extends WomenCallManifestoEvent {}

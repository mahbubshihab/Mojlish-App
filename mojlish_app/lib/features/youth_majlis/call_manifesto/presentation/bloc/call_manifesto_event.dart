import 'package:equatable/equatable.dart';

abstract class YouthCallManifestoEvent extends Equatable {
  const YouthCallManifestoEvent();
  @override
  List<Object?> get props => [];
}

class LoadYouthCallManifestoData extends YouthCallManifestoEvent {}

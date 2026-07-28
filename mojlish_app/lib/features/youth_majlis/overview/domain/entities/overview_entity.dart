import 'package:equatable/equatable.dart';

class OverviewEntity extends Equatable {
  final String title;
  final String content;

  const OverviewEntity({
    required this.title,
    required this.content,
  });

  @override
  List<Object?> get props => [title, content];
}

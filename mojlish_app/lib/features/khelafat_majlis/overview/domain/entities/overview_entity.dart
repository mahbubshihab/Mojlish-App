import 'package:equatable/equatable.dart';

class OverviewEntity extends Equatable {
  final String title;
  final String description;
  final List<String> basicPrograms;
  final List<String> membershipConditions;

  const OverviewEntity({
    required this.title,
    required this.description,
    required this.basicPrograms,
    required this.membershipConditions,
  });

  @override
  List<Object?> get props => [title, description, basicPrograms, membershipConditions];
}

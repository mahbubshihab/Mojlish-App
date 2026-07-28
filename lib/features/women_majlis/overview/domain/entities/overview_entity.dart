import 'package:equatable/equatable.dart';

class OverviewEntity extends Equatable {
  final String title;
  final String description;
  final List<String> aimsAndObjectives;
  final List<String> programs;
  final List<String> manpowerTiers;

  const OverviewEntity({
    required this.title,
    required this.description,
    required this.aimsAndObjectives,
    required this.programs,
    required this.manpowerTiers,
  });

  @override
  List<Object?> get props => [title, description, aimsAndObjectives, programs, manpowerTiers];
}

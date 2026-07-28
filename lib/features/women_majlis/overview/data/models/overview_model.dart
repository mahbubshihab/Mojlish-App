import '../../domain/entities/overview_entity.dart';

class OverviewModel extends OverviewEntity {
  const OverviewModel({
    required super.title,
    required super.description,
    required super.aimsAndObjectives,
    required super.programs,
    required super.manpowerTiers,
  });

  factory OverviewModel.fromJson(Map<String, dynamic> json) {
    return OverviewModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      aimsAndObjectives: List<String>.from(json['aimsAndObjectives'] ?? []),
      programs: List<String>.from(json['programs'] ?? []),
      manpowerTiers: List<String>.from(json['manpowerTiers'] ?? []),
    );
  }
}

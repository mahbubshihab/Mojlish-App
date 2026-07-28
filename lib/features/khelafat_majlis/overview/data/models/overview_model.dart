import '../../domain/entities/overview_entity.dart';

class OverviewModel extends OverviewEntity {
  const OverviewModel({
    required super.title,
    required super.description,
    required super.basicPrograms,
    required super.membershipConditions,
  });

  factory OverviewModel.fromJson(Map<String, dynamic> json) {
    return OverviewModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      basicPrograms: List<String>.from(json['basicPrograms'] ?? []),
      membershipConditions: List<String>.from(json['membershipConditions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'basicPrograms': basicPrograms,
      'membershipConditions': membershipConditions,
    };
  }
}

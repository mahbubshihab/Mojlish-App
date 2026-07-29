import '../../domain/entities/khelafot_syllabus_entity.dart';

class KhelafotSyllabusModel extends KhelafotSyllabusEntity {
  const KhelafotSyllabusModel({
    required super.id,
    required super.title,
    required super.description,
    super.data,
  });

  factory KhelafotSyllabusModel.fromJson(Map<String, dynamic> json) {
    return KhelafotSyllabusModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}

import '../../domain/entities/khelafot_syllabus_entity.dart';

class KhelafotSyllabusModel extends KhelafotSyllabusEntity {
  const KhelafotSyllabusModel({
    required String id,
    required String title,
    required String description,
    KhelafotSyllabusData? data,
  }) : super(id: id, title: title, description: description, data: data);

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

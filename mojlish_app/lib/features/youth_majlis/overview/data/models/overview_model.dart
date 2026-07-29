import '../../domain/entities/overview_entity.dart';

class OverviewModel extends OverviewEntity {
  const OverviewModel({
    required super.title,
    required super.content,
  });

  factory OverviewModel.fromJson(Map<String, dynamic> json) {
    return OverviewModel(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}

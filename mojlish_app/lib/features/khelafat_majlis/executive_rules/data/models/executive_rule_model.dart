import '../../domain/entities/executive_rule.dart';

class ExecutiveRuleModel extends ExecutiveRule {
  const ExecutiveRuleModel({
    required super.id,
    required super.title,
    required super.content,
    required super.imageUrl,
  });

  factory ExecutiveRuleModel.fromJson(Map<String, dynamic> json) {
    return ExecutiveRuleModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
    };
  }
}

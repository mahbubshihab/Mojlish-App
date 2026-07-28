import '../../domain/entities/call_manifesto.dart';

class CallManifestoModel extends CallManifesto {
  const CallManifestoModel({
    required super.id,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.createdAt,
  });

  factory CallManifestoModel.fromJson(Map<String, dynamic> json) {
    return CallManifestoModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

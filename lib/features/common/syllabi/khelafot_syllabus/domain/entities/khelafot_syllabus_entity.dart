import 'package:equatable/equatable.dart';

class SyllabusBook extends Equatable {
  final String id;
  final String title;
  final String author;
  final String? publisher;
  final bool isMandatory; // true = পাঠ্য বই, false = সহায়ক বই
  final bool isCompleted;

  const SyllabusBook({
    required this.id,
    required this.title,
    required this.author,
    this.publisher,
    this.isMandatory = true,
    this.isCompleted = false,
  });

  SyllabusBook copyWith({
    String? id,
    String? title,
    String? author,
    String? publisher,
    bool? isMandatory,
    bool? isCompleted,
  }) {
    return SyllabusBook(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      publisher: publisher ?? this.publisher,
      isMandatory: isMandatory ?? this.isMandatory,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, title, author, publisher, isMandatory, isCompleted];
}

class SyllabusCategory extends Equatable {
  final String id;
  final String name;
  final List<String> topics;
  final List<SyllabusBook> books;

  const SyllabusCategory({
    required this.id,
    required this.name,
    required this.topics,
    required this.books,
  });

  @override
  List<Object?> get props => [id, name, topics, books];
}

class SyllabusLevel extends Equatable {
  final String id;
  final String levelTitle;
  final String subtitle;
  final String description;
  final List<SyllabusCategory> categories;

  const SyllabusLevel({
    required this.id,
    required this.levelTitle,
    required this.subtitle,
    required this.description,
    required this.categories,
  });

  @override
  List<Object?> get props => [id, levelTitle, subtitle, description, categories];
}

class DiscussionNoteTopicGroup extends Equatable {
  final String categoryName;
  final List<String> topics;

  const DiscussionNoteTopicGroup({
    required this.categoryName,
    required this.topics,
  });

  @override
  List<Object?> get props => [categoryName, topics];
}

class KhelafotSyllabusData extends Equatable {
  final String organizationName;
  final String address;
  final String phone;
  final String email;
  final String website;
  final String publicationDate;
  final String price;
  final String introduction;
  final List<SyllabusLevel> levels;
  final List<DiscussionNoteTopicGroup> discussionTopics;

  const KhelafotSyllabusData({
    required this.organizationName,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.publicationDate,
    required this.price,
    required this.introduction,
    required this.levels,
    required this.discussionTopics,
  });

  @override
  List<Object?> get props => [
        organizationName,
        address,
        phone,
        email,
        website,
        publicationDate,
        price,
        introduction,
        levels,
        discussionTopics,
      ];
}

class KhelafotSyllabusEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final KhelafotSyllabusData? data;

  const KhelafotSyllabusEntity({
    required this.id,
    required this.title,
    required this.description,
    this.data,
  });

  @override
  List<Object?> get props => [id, title, description, data];
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mimo/core/entity/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel(
      {required super.title,
      required super.emoji,
      required super.categoryId,
      required super.userId,
      required super.createdAt});

  factory CategoryModel.fromJson(
      QueryDocumentSnapshot<Map<String, dynamic>> json) {
    return CategoryModel(
      userId: json.data()['userId'],
      categoryId: json.data()['categoryId'],
      createdAt: json.data()['createdAt'].toDate(),
      emoji: json.data()['emoji'],
      title: json.data()['title'],
    );
  }

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      userId: entity.userId,
      categoryId: entity.categoryId,
      createdAt: entity.createdAt,
      emoji: entity.emoji,
      title: entity.title,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'categoryId': categoryId,
      'createdAt': createdAt,
      'emoji': emoji,
      'title': title,
    };
  }
}

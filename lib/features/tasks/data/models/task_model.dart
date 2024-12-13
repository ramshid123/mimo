import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mimo/core/entity/task_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel(
      {required super.taskText,
      required super.isCompleted,
      required super.categoryId,
      required super.userId,
      required super.taskId,
      required super.taskDate,
      required super.createdAt});

  factory TaskModel.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    return TaskModel(
      userId: json.data()['userId'],
      categoryId: json.data()['categoryId'],
      createdAt: json.data()['createdAt'].toDate(),
      isCompleted: json.data()['isCompleted'],
      taskText: json.data()['taskText'],
      taskId: json.data()['taskId'],
      taskDate: json.data()['taskDate'].toDate(),
    );
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      userId: entity.userId,
      categoryId: entity.categoryId,
      createdAt: entity.createdAt,
      isCompleted: entity.isCompleted,
      taskText: entity.taskText,
      taskId: entity.taskId,
      taskDate: entity.taskDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'categoryId': categoryId,
      'createdAt': createdAt,
      'isCompleted': isCompleted,
      'taskText': taskText,
      'taskId': taskId,
      'taskDate': taskDate,
    };
  }
}

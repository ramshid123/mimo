import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mimo/core/constants/collections.dart';
import 'package:mimo/core/error/exception.dart';
import 'package:mimo/features/tasks/data/models/category_model.dart';
import 'package:mimo/features/tasks/data/models/task_model.dart';
import 'package:uuid/uuid.dart';

abstract interface class TasksRemoteSource {
  Future<void> createCategory(CategoryModel category);

  Future<void> createTask(TaskModel task);

  Future<List<CategoryModel>> getCategories(String userId);

  Future<List<TaskModel>> getTasks(String categoryId);

  Future<void> updateTask({required bool value, required String taskId});

  Future<int> getTasksCount(String categoryId);
}

class TasksRemoteSourceImpl implements TasksRemoteSource {
  final FirebaseFirestore firestoreDb;

  TasksRemoteSourceImpl(this.firestoreDb);

  @override
  Future<void> createCategory(CategoryModel category) async {
    try {
      await firestoreDb
          .collection(FirestoreCollections.categories)
          .doc(
              '${category.userId}_${category.categoryId}_${DateTime.now().millisecondsSinceEpoch}_${Uuid().v1()}')
          .set(category.toJson());
    } catch (e) {
      throw KustomException(e.toString());
    }
  }

  @override
  Future<void> createTask(TaskModel task) async {
    try {
      await firestoreDb
          .collection(FirestoreCollections.tasks)
          .doc(
              '${task.taskId}_${task.categoryId}_${task.userId}_${DateTime.now().millisecondsSinceEpoch}_${Uuid().v1()}')
          .set(task.toJson());
    } catch (e) {
      throw KustomException(e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getCategories(String userId) async {
    try {
      final response = await firestoreDb
          .collection(FirestoreCollections.categories)
          .where('userId', isEqualTo: userId)
          .get();

      return response.docs.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      throw KustomException(e.toString());
    }
  }

  @override
  Future<List<TaskModel>> getTasks(String categoryId) async {
    try {
      final response = await firestoreDb
          .collection(FirestoreCollections.tasks)
          .where('categoryId', isEqualTo: categoryId)
          .get();

      return response.docs.map((e) => TaskModel.fromJson(e)).toList();
    } catch (e) {
      throw KustomException(e.toString());
    }
  }

  @override
  Future<void> updateTask({required bool value, required String taskId}) async {
    try {
      final response = await firestoreDb
          .collection(FirestoreCollections.tasks)
          .where('taskId', isEqualTo: taskId)
          .get();
      response.docs.first.reference.update({
        'isCompleted': value,
      });
    } catch (e) {
      throw KustomException(e.toString());
    }
  }

  @override
  Future<int> getTasksCount(String categoryId) async {
    try {
      final respnose = await firestoreDb
          .collection(FirestoreCollections.tasks)
          .where('categoryId', isEqualTo: categoryId)
          .where('taskDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day)))
          .count()
          .get();
      return respnose.count ?? 0;
    } catch (e) {
      throw KustomException(e.toString());
    }
  }
}

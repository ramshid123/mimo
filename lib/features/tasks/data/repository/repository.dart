import 'package:fpdart/fpdart.dart';
import 'package:mimo/core/entity/category_entity.dart';
import 'package:mimo/core/entity/task_entity.dart';
import 'package:mimo/core/entity/user_entity.dart';
import 'package:mimo/core/error/exception.dart';
import 'package:mimo/core/error/kfailure.dart';
import 'package:mimo/features/tasks/data/data%20source/remote_data_source.dart';
import 'package:mimo/features/tasks/data/models/category_model.dart';
import 'package:mimo/features/tasks/data/models/task_model.dart';
import 'package:mimo/features/tasks/domain/repository/repository.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v1.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TasksRemoteSource tasksRemoteSource;

  TaskRepositoryImpl(this.tasksRemoteSource);

  @override
  Future<Either<KFailure, void>> createCategory(
      {required String title,
      required String emoji,
      required String userId}) async {
    try {
      final category = CategoryModel(
        title: title,
        emoji: emoji,
        categoryId: '${userId}_${Uuid().v1()}',
        userId: userId,
        createdAt: DateTime.now(),
      );

      await tasksRemoteSource.createCategory(category);
      return right(null);
    } on KustomException catch (e) {
      return left(KFailure(e.error));
    }
  }

  @override
  Future<Either<KFailure, void>> createTask(
      {required String text,
      required String categoryId,
      required DateTime taskDate,
      required String userId}) async {
    try {
      final task = TaskModel(
        taskText: text,
        isCompleted: false,
        categoryId: categoryId,
        userId: userId,
        taskId: '${userId}_${Uuid().v1()}',
        taskDate: taskDate,
        createdAt: DateTime.now(),
      );

      await tasksRemoteSource.createTask(TaskModel.fromEntity(task));
      return right(null);
    } on KustomException catch (e) {
      return left(KFailure(e.error));
    }
  }

  @override
  Future<Either<KFailure, List<CategoryEntity>>> getCategories(
      String userId) async {
    try {
      final response = await tasksRemoteSource.getCategories(userId);
      return right(response);
    } on KustomException catch (e) {
      return left(KFailure(e.error));
    }
  }

  @override
  Future<Either<KFailure, List<TaskEntity>>> getTasks(String categoryId) async {
    try {
      final response = await tasksRemoteSource.getTasks(categoryId);
      return right(response);
    } on KustomException catch (e) {
      return left(KFailure(e.error));
    }
  }

  @override
  Future<Either<KFailure, String>> updateTask(
      {required bool value, required String taskId}) async {
    try {
      await tasksRemoteSource.updateTask(value: value, taskId: taskId);
      return right(taskId);
    } on KustomException catch (e) {
      return left(KFailure(e.error));
    }
  }

  @override
  Future<Either<KFailure, int>> getTasksCount(String categoryId) async {
    try {
      final response = await tasksRemoteSource.getTasksCount(categoryId);
      return right(response);
    } on KustomException catch (e) {
      return left(KFailure(e.error));
    }
  }
}

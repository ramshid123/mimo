import 'package:fpdart/fpdart.dart';
import 'package:mimo/core/entity/category_entity.dart';
import 'package:mimo/core/entity/task_entity.dart';
import 'package:mimo/core/error/kfailure.dart';

abstract interface class TaskRepository {
  Future<Either<KFailure, void>> createCategory(
      {required String title, required String emoji, required String userId});

  Future<Either<KFailure, void>> createTask(
      {required String text,
      required String categoryId,
      required String userId,
      required DateTime taskDate});

  Future<Either<KFailure, List<CategoryEntity>>> getCategories(String userId);

  Future<Either<KFailure, List<TaskEntity>>> getTasks(String categoryId);

  Future<Either<KFailure, String>> updateTask(
      {required bool value, required String taskId});

  Future<Either<KFailure, int>> getTasksCount(String categoryId);
}

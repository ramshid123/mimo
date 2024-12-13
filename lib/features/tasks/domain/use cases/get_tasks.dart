import 'package:fpdart/fpdart.dart';
import 'package:mimo/core/entity/task_entity.dart';
import 'package:mimo/core/error/kfailure.dart';
import 'package:mimo/core/usecase/usecase.dart';
import 'package:mimo/features/tasks/domain/repository/repository.dart';

class UseCaseGetTasks
    implements Usecase<List<TaskEntity>, UseCaseGetTasksParams> {
  final TaskRepository taskRepository;

  UseCaseGetTasks(this.taskRepository);

  @override
  Future<Either<KFailure, List<TaskEntity>>> call(
      UseCaseGetTasksParams params) async {
    return await taskRepository.getTasks(params.categoryId);
  }
}

final class UseCaseGetTasksParams {
  final String categoryId;

  UseCaseGetTasksParams(this.categoryId);
}

import 'package:fpdart/src/either.dart';
import 'package:mimo/core/error/kfailure.dart';
import 'package:mimo/core/usecase/usecase.dart';
import 'package:mimo/features/tasks/domain/repository/repository.dart';

class UseCaseGetTasksCount implements Usecase<int, UseCaseGetTasksCountParams> {
  final TaskRepository taskRepository;

  UseCaseGetTasksCount(this.taskRepository);
  @override
  Future<Either<KFailure, int>> call(UseCaseGetTasksCountParams params) async {
    return await taskRepository.getTasksCount(params.categoryId);
  }
}

class UseCaseGetTasksCountParams {
  final String categoryId;

  UseCaseGetTasksCountParams(this.categoryId);
}

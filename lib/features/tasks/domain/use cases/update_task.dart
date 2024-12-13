import 'package:fpdart/fpdart.dart';
import 'package:mimo/core/error/kfailure.dart';
import 'package:mimo/core/usecase/usecase.dart';
import 'package:mimo/features/tasks/domain/repository/repository.dart';

class UseCaseUpdateTask implements Usecase<String, UseCaseUpdateTaskParams> {
  final TaskRepository taskRepository;

  UseCaseUpdateTask(this.taskRepository);

  @override
  Future<Either<KFailure, String>> call(UseCaseUpdateTaskParams params) async {
    return await taskRepository.updateTask(
        value: params.value, taskId: params.taskId);
  }
}

class UseCaseUpdateTaskParams {
  final String taskId;
  final bool value;

  UseCaseUpdateTaskParams({required this.taskId, required this.value});
}

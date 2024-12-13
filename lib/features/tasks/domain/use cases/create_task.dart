import 'package:fpdart/fpdart.dart';
import 'package:mimo/core/error/kfailure.dart';
import 'package:mimo/core/usecase/usecase.dart';
import 'package:mimo/features/tasks/domain/repository/repository.dart';

class UseCaseCreateTask implements Usecase<void, UseCaseCreateTaskParams> {
  final TaskRepository taskRepository;

  UseCaseCreateTask(this.taskRepository);

  @override
  Future<Either<KFailure, void>> call(UseCaseCreateTaskParams params) async {
    return await taskRepository.createTask(
      text: params.text,
      categoryId: params.categoryId,
      userId: params.userId,
      taskDate: params.taskDate,
    );
  }
}

class UseCaseCreateTaskParams {
  final String text;
  final String categoryId;
  final DateTime taskDate;
  final String userId;

  UseCaseCreateTaskParams({
    required this.text,
    required this.categoryId,
    required this.userId,
    required this.taskDate,
  });
}

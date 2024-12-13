import 'package:fpdart/fpdart.dart';
import 'package:mimo/core/error/kfailure.dart';
import 'package:mimo/core/usecase/usecase.dart';
import 'package:mimo/features/tasks/domain/repository/repository.dart';

class UseCaseCreateCategory
    implements Usecase<void, UseCaseCreateCategoryParams> {
  final TaskRepository taskRepository;

  UseCaseCreateCategory(this.taskRepository);

  @override
  Future<Either<KFailure, void>> call(
      UseCaseCreateCategoryParams params) async {
    return await taskRepository.createCategory(
        title: params.title, emoji: params.emoji, userId: params.userId);
  }
}

class UseCaseCreateCategoryParams {
  final String title;
  final String emoji;
  final String userId;

  UseCaseCreateCategoryParams(
      {required this.title, required this.emoji, required this.userId});
}

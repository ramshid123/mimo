import 'package:fpdart/fpdart.dart';
import 'package:mimo/core/entity/category_entity.dart';
import 'package:mimo/core/error/kfailure.dart';
import 'package:mimo/core/usecase/usecase.dart';
import 'package:mimo/features/tasks/domain/repository/repository.dart';

class UseCaseGetCategories
    implements Usecase<List<CategoryEntity>, UseCaseGetCategoriesParams> {
  final TaskRepository taskRepository;

  UseCaseGetCategories(this.taskRepository);

  @override
  Future<Either<KFailure, List<CategoryEntity>>> call(
      UseCaseGetCategoriesParams params) async {
    return await taskRepository.getCategories(params.userId);
  }
}

final class UseCaseGetCategoriesParams {
  final String userId;

  UseCaseGetCategoriesParams(this.userId);
}

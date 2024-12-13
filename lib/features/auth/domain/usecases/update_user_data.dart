import 'package:fpdart/fpdart.dart';
import 'package:mimo/core/entity/user_entity.dart';
import 'package:mimo/core/error/kfailure.dart';
import 'package:mimo/core/usecase/usecase.dart';
import 'package:mimo/features/auth/domain/repository/auth_repository.dart';

class UseCaseUpdateUserData
    implements Usecase<UserEntity, UseCaseUpdateUserDataParams> {
  final AuthRepository authRepository;

  UseCaseUpdateUserData(this.authRepository);

  @override
  Future<Either<KFailure, UserEntity>> call(
      UseCaseUpdateUserDataParams params) async {
    return await authRepository.updateUserData(params.user);
  }
}

class UseCaseUpdateUserDataParams {
  final UserEntity user;

  UseCaseUpdateUserDataParams(this.user);
}

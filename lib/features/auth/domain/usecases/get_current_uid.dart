import 'package:fpdart/fpdart.dart';
import 'package:mimo/core/entity/user_entity.dart';
import 'package:mimo/core/error/kfailure.dart';
import 'package:mimo/core/usecase/usecase.dart';
import 'package:mimo/features/auth/domain/repository/auth_repository.dart';


class UseCaseGetCurrentUid
    implements Usecase<UserEntity?, UseCaseGetCurrentUidParams> {
  final AuthRepository authRepository;

  UseCaseGetCurrentUid(this.authRepository);

  @override
  Future<Either<KFailure, UserEntity?>> call(
      UseCaseGetCurrentUidParams params) async {
    return await authRepository.getCurrentUser();
  }
}

class UseCaseGetCurrentUidParams {}

import 'package:fpdart/fpdart.dart';
import 'package:mimo/core/entity/user_entity.dart';
import 'package:mimo/core/error/kfailure.dart';
import 'package:mimo/core/usecase/usecase.dart';
import 'package:mimo/features/auth/domain/repository/auth_repository.dart';


class UseCaseLogin implements Usecase<UserEntity?, UseCaseLoginParams> {
  final AuthRepository authRepository;

  UseCaseLogin(this.authRepository);

  @override
  Future<Either<KFailure, UserEntity?>> call(UseCaseLoginParams params) async {
    return await authRepository.login(
        email: params.email, password: params.password);
  }
}

class UseCaseLoginParams {
  final String email;
  final String password;

  UseCaseLoginParams({required this.email, required this.password});
}

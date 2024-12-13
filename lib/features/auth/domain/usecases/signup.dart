import 'package:fpdart/fpdart.dart';
import 'package:mimo/core/entity/user_entity.dart';
import 'package:mimo/core/error/kfailure.dart';
import 'package:mimo/core/usecase/usecase.dart';
import 'package:mimo/features/auth/domain/repository/auth_repository.dart';

class UseCaseSignup implements Usecase<UserEntity, UseCaseSignupParams> {
  final AuthRepository authRepository;

  UseCaseSignup(this.authRepository);

  @override
  Future<Either<KFailure, UserEntity>> call(UseCaseSignupParams params) async {
    return await authRepository.signup(
      email: params.email,
      password: params.password,
      fullname: params.fullname,
    );
  }
}

class UseCaseSignupParams {
  final String fullname;
  final String email;
  final String password;

  UseCaseSignupParams(
      {required this.fullname,
      required this.email,
      required this.password});
}

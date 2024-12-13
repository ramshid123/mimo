import 'package:fpdart/fpdart.dart';
import 'package:mimo/core/error/kfailure.dart';
import 'package:mimo/core/usecase/usecase.dart';
import 'package:mimo/features/auth/domain/repository/auth_repository.dart';

class UseCaseResetPasswordEmail
    implements Usecase<void, UseCaseResetPasswordEmailParams> {
  final AuthRepository authRepository;

  UseCaseResetPasswordEmail(this.authRepository);

  @override
  Future<Either<KFailure, void>> call(
      UseCaseResetPasswordEmailParams params) async {
    return await authRepository.sendResetPasswordEmail(params.email);
  }
}

class UseCaseResetPasswordEmailParams {
  final String email;

  UseCaseResetPasswordEmailParams(this.email);
}

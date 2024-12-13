import 'package:fpdart/fpdart.dart';
import 'package:mimo/core/error/kfailure.dart';
import 'package:mimo/core/usecase/usecase.dart';
import 'package:mimo/features/auth/domain/repository/auth_repository.dart';


class UseCaseLogout implements Usecase<void, UseCaseLogoutParams> {
  final AuthRepository authRepository;

  UseCaseLogout(this.authRepository);

  @override
  Future<Either<KFailure, void>> call(UseCaseLogoutParams params) async {
    return await authRepository.logout();
  }
}

class UseCaseLogoutParams {}

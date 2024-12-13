import 'package:fpdart/fpdart.dart';
import 'package:mimo/core/entity/user_entity.dart';
import 'package:mimo/core/error/kfailure.dart';

abstract interface class AuthRepository {
  Future<Either<KFailure, UserEntity?>> login({
    required String email,
    required String password,
  });

  Future<Either<KFailure, UserEntity>> signup({
    required String email,
    required String password,
    required String fullname,
  });

  Future<Either<KFailure, UserEntity?>> getCurrentUser();

  Future<Either<KFailure, void>> logout();

  Future<Either<KFailure, UserEntity>> updateUserData(UserEntity user);

  Future<Either<KFailure, void>> sendResetPasswordEmail(String email);

}

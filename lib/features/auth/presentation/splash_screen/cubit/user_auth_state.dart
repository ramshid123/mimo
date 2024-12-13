part of 'user_auth_cubit.dart';

@immutable
sealed class UserAuthState {}

final class UserAuthInitial extends UserAuthState {}

final class UserAuthStateResult extends UserAuthState {
  final UserEntity? user;

  UserAuthStateResult(this.user);
}

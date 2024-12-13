part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserStateUserEntity extends UserState {
  final UserEntity userEntity;

  UserStateUserEntity(this.userEntity);
}

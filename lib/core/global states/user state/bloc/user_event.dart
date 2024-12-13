part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

final class UserEventUserUpdate extends UserEvent {
  final UserEntity userEntity;

  UserEventUserUpdate(this.userEntity);
}

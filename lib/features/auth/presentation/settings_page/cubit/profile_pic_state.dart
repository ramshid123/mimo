part of 'profile_pic_cubit.dart';

@immutable
sealed class ProfilePicState {}

final class ProfilePicInitial extends ProfilePicState {}

final class ProfilePicStateFailure extends ProfilePicState {
  final String msg;

  ProfilePicStateFailure(this.msg);
}

final class ProfilePicStateSuccess extends ProfilePicState {
  final String fileId;

  ProfilePicStateSuccess(this.fileId);
}

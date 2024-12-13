part of 'edit_profile_cubit.dart';

@immutable
sealed class EditProfileState {}

final class EditProfileInitial extends EditProfileState {}

final class EditProfileStateLoading extends EditProfileState {}

final class EditProfileStateFailure extends EditProfileState {
  final String errorMsg;

  EditProfileStateFailure(this.errorMsg);
}

final class EditProfileStateDataUpdated extends EditProfileState {
  final UserEntity user;

  EditProfileStateDataUpdated(this.user);
}

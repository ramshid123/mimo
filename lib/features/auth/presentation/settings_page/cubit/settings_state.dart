part of 'settings_cubit.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class SettingsStateLogoutSuccess extends SettingsState {}

final class SettingsStateFailure extends SettingsState {
  final String errormsg;

  SettingsStateFailure(this.errormsg);
}

final class SettingsStateUserUpdated extends SettingsState {
  final UserEntity user;

  SettingsStateUserUpdated(this.user);
}

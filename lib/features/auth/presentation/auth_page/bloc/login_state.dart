part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginStateLoading extends LoginState {}

final class LoginStateSuccess extends LoginState {
  final UserEntity user;

  LoginStateSuccess(this.user);
}

final class LoginStateFailure extends LoginState {
  final String errormsg;

  LoginStateFailure(this.errormsg);
}

final class LoginStateEmailSent extends LoginState{}
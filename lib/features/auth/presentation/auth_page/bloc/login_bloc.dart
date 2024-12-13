import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mimo/core/entity/user_entity.dart';
import 'package:mimo/features/auth/domain/usecases/login.dart';
import 'package:mimo/features/auth/domain/usecases/send_reset_pass_email.dart';
import 'package:mimo/features/auth/domain/usecases/signup.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UseCaseSignup _useCaseSignup;
  final UseCaseLogin _useCaseLogin;
  final UseCaseResetPasswordEmail _useCaseResetPasswordEmail;

  LoginBloc(
      {required UseCaseLogin useCaseLogin,
      required UseCaseResetPasswordEmail useCaseResetPasswordEmail,
      required UseCaseSignup useCaseSignup})
      : _useCaseSignup = useCaseSignup,
        _useCaseLogin = useCaseLogin,
        _useCaseResetPasswordEmail = useCaseResetPasswordEmail,
        super(LoginInitial()) {
    on<LoginEvent>((event, emit) {});

    on<LoginEventSignup>(
        (event, emit) async => await _onLoginEventSignup(event, emit));

    on<LoginEventLogin>(
        (event, emit) async => await _onLoginEventLogin(event, emit));

    on<LoginEventForgotPassword>(
        (event, emit) async => await _onLoginEventForgotPassword(event, emit));
  }

  Future _onLoginEventForgotPassword(
      LoginEventForgotPassword event, Emitter<LoginState> emit) async {
    emit(LoginStateLoading());
    final response = await _useCaseResetPasswordEmail(
        UseCaseResetPasswordEmailParams(event.email));

    response.fold(
      (l) {
        log(l.message);
      },
      (r) {
        emit(LoginStateEmailSent());
      },
    );
  }

  Future _onLoginEventLogin(
      LoginEventLogin event, Emitter<LoginState> emit) async {
    emit(LoginStateLoading());

    if (event.email.trim().isEmpty || event.password.trim().isEmpty) {
      emit(LoginStateFailure('Please fill all the fields.'));
    } else {
      final response = await _useCaseLogin(UseCaseLoginParams(
          email: event.email.trim(), password: event.password));
      response.fold(
        (l) {
          emit(LoginStateFailure('Unable to login. Please try again'));
        },
        (r) {
          if (r == null) {
            emit(LoginStateFailure(
                'Please check your credentials and try again.'));
          } else {
            emit(LoginStateSuccess(r));
          }
        },
      );
    }
  }

  Future _onLoginEventSignup(
      LoginEventSignup event, Emitter<LoginState> emit) async {
    emit(LoginStateLoading());

    if (event.email.trim().isEmpty ||
        event.password.trim().isEmpty ||
        event.fullname.trim().isEmpty ||
        event.confirmPass.trim().isEmpty) {
      emit(LoginStateFailure('Please fill all fields correctly'));
    } else if (event.confirmPass != event.password) {
      emit(LoginStateFailure('Passwords do not match'));
    } else {
      final response = await _useCaseSignup(UseCaseSignupParams(
        fullname: event.fullname.trim(),
        email: event.email.trim(),
        password: event.password,
      ));

      response.fold(
        (l) {
          emit(LoginStateFailure('Unable to login. Please try again.'));
        },
        (r) {
          emit(LoginStateSuccess(r));
        },
      );
    }
  }
}

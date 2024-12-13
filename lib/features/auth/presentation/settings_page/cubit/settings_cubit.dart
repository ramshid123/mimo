import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mimo/core/entity/user_entity.dart';
import 'package:mimo/features/auth/domain/usecases/logout.dart';
import 'package:mimo/features/auth/domain/usecases/update_user_data.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final UseCaseLogout _useCaseLogout;
  final UseCaseUpdateUserData _useCaseUpdateUserData;

  SettingsCubit({
    required UseCaseLogout useCaseLogout,
    required UseCaseUpdateUserData useCaseUpdateUserData,
  })  : _useCaseLogout = useCaseLogout,
        _useCaseUpdateUserData = useCaseUpdateUserData,
        super(SettingsInitial());

  Future logout() async {
    final response = await _useCaseLogout(UseCaseLogoutParams());

    response.fold(
      (l) {
        emit(SettingsStateFailure(l.message));
      },
      (r) {
        emit(SettingsStateLogoutSuccess());
      },
    );
  }

  Future updateUserData(UserEntity user) async {
    final response =
        await _useCaseUpdateUserData(UseCaseUpdateUserDataParams(user));

    response.fold(
      (l) {
        log(l.message);
        emit(SettingsStateFailure(l.message));
      },
      (r) {
        emit(SettingsStateUserUpdated(r));
      },
    );
  }
}

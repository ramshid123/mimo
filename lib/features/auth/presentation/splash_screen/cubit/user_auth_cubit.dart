import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mimo/core/entity/user_entity.dart';
import 'package:mimo/features/auth/domain/usecases/get_current_uid.dart';

part 'user_auth_state.dart';

class UserAuthCubit extends Cubit<UserAuthState> {
  final UseCaseGetCurrentUid _useCaseGetCurrentUid;

  UserAuthCubit({
    required UseCaseGetCurrentUid useCaseGetCurrentUid,
  })  : _useCaseGetCurrentUid = useCaseGetCurrentUid,
        super(UserAuthInitial());

  Future checkForLogin() async {
    final response = await _useCaseGetCurrentUid(UseCaseGetCurrentUidParams());

    response.fold(
      (l) {
        log(l.message);
      },
      (r) {
        emit(UserAuthStateResult(r));
      },
    );
  }
}

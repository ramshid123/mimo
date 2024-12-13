import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mimo/features/auth/domain/usecases/upload_profile_pic.dart';

part 'profile_pic_state.dart';

class ProfilePicCubit extends Cubit<ProfilePicState> {
  final UseCaseUploadProfilepic _useCaseUploadProfilepic;

  ProfilePicCubit({
    required UseCaseUploadProfilepic useCaseUploadProfilepic,
  })  : _useCaseUploadProfilepic = useCaseUploadProfilepic,
        super(ProfilePicInitial());

  Future uploadProfilePic(String? fileId) async {
    final response =
        await _useCaseUploadProfilepic(UseCaseUploadProfilepicParams(fileId));

    response.fold(
      (l) {
        log(l.message);
        emit(ProfilePicStateFailure(l.message));
      },
      (r) {
        if (r == null) {
          emit(ProfilePicStateFailure('Failed to upload profile picture'));
        } else {
          emit(ProfilePicStateSuccess(r));
        }
      },
    );
  }
}

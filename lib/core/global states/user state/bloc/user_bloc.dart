import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mimo/core/entity/user_entity.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) {
      
    });

    on<UserEventUserUpdate>((event, emit) {
      emit(UserStateUserEntity(event.userEntity));
    });
  }
}

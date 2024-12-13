import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mimo/core/entity/category_entity.dart';
import 'package:mimo/features/tasks/domain/use%20cases/create_category.dart';
import 'package:mimo/features/tasks/domain/use%20cases/get_categories.dart';
part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final UseCaseCreateCategory _useCaseCreateCategory;
  final UseCaseGetCategories _useCaseGetCategories;

  CategoriesBloc({
    required UseCaseCreateCategory useCaseCreateCategory,
    required UseCaseGetCategories useCaseGetCategories,
  })  : _useCaseCreateCategory = useCaseCreateCategory,
        _useCaseGetCategories = useCaseGetCategories,
        super(CategoriesInitial()) {
    on<CategoriesEvent>((event, emit) {
      
    });

    on<CategoriesEventAddCategory>((event, emit) async =>
        await _onCategoriesEventAddCategory(event, emit));

    on<CategoriesEventGetCategories>((event, emit) async =>
        await _onCategoriesEventGetCategories(event, emit));
  }

  Future _onCategoriesEventGetCategories(
      CategoriesEventGetCategories event, Emitter<CategoriesState> emit) async {
    emit(CategoriesStateLoading());
    final rsponse =
        await _useCaseGetCategories(UseCaseGetCategoriesParams(event.userId));

    rsponse.fold(
      (l) {
        log(l.message);
        emit(CategoriesStateFailure(l.message));
      },
      (r) {
        emit(CategoriesStateCategories(r));
      },
    );
  }

  Future _onCategoriesEventAddCategory(
      CategoriesEventAddCategory event, Emitter<CategoriesState> emit) async {
    emit(CategoriesStateLoading());

    final response = await _useCaseCreateCategory(UseCaseCreateCategoryParams(
        title: event.title, emoji: event.emoji, userId: event.userId));

    response.fold(
      (l) {
        emit(CategoriesStateFailure(l.message));
      },
      (r) {
        emit(CategoriesStateCategoryAdded());
      },
    );
  }
}

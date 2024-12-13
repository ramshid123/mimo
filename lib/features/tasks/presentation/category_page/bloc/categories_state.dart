part of 'categories_bloc.dart';

@immutable
sealed class CategoriesState {}

final class CategoriesInitial extends CategoriesState {}

final class CategoriesStateLoading extends CategoriesState {}

final class CategoriesStateCategoryAdded extends CategoriesState {}

final class CategoriesStateFailure extends CategoriesState {
  final String msg;

  CategoriesStateFailure(this.msg);
}

final class CategoriesStateCategories extends CategoriesState {
  final List<CategoryEntity> categories;

  CategoriesStateCategories(this.categories);
}

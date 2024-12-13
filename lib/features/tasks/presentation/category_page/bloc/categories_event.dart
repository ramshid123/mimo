part of 'categories_bloc.dart';

@immutable
sealed class CategoriesEvent {}

final class CategoriesEventAddCategory extends CategoriesEvent {
  final String title;
  final String emoji;
  final String userId;

  CategoriesEventAddCategory(
      {required this.title, required this.emoji, required this.userId});
}

final class CategoriesEventGetCategories extends CategoriesEvent {
  final String userId;

  CategoriesEventGetCategories(this.userId);
}

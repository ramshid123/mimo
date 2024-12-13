class CategoryEntity {
  final String title;
  final String emoji;
  final String categoryId;
  final String userId;
  final DateTime createdAt;

  CategoryEntity(
      {required this.title,
      required this.emoji,
      required this.categoryId,
      required this.userId,
      required this.createdAt});
}

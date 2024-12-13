class TaskEntity {
  final String taskText;
  final String taskId;
  final bool isCompleted;
  final String categoryId;
  final String userId;
  final DateTime createdAt;
  final DateTime taskDate;

  TaskEntity({
    required this.taskText,
    required this.isCompleted,
    required this.categoryId,
    required this.taskId,
    required this.userId,
    required this.createdAt,
    required this.taskDate,
  });
}

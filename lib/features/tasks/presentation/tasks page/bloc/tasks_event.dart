part of 'tasks_bloc.dart';

@immutable
sealed class TasksEvent {}

final class TasksEventGetTasks extends TasksEvent {
  final String categoryId;

  TasksEventGetTasks(this.categoryId);
}

final class TasksEventAddTask extends TasksEvent {
  final String text;
  final String categoryId;
  final DateTime taskDate;
  final String userId;

  TasksEventAddTask({
    required this.text,
    required this.categoryId,
    required this.userId,
    required this.taskDate,
  });
}

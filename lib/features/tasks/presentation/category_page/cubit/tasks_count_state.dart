part of 'tasks_count_cubit.dart';

@immutable
sealed class TasksCountState {}

final class TasksCountInitial extends TasksCountState {}

final class TasksCountStateTasksCount extends TasksCountState {
  final int count;
  final String categoryId;

  TasksCountStateTasksCount({
    required this.count,
    required this.categoryId,
  });
}

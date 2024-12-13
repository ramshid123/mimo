part of 'tasks_bloc.dart';

@immutable
sealed class TasksState {}

final class TasksInitial extends TasksState {}

final class TasksStateTaskAdded extends TasksState {}

final class TasksStateLoading extends TasksState {}

final class TasksStateTasks extends TasksState {
  final Map<String, List<TaskEntity>> groupedTasks;

  TasksStateTasks(this.groupedTasks);
}

final class TasksStateFailure extends TasksState {
  final String message;

  TasksStateFailure(this.message);
}

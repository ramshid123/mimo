part of 'task_cubit.dart';

@immutable
sealed class SingleTaskState {}

final class SingleTaskInitial extends SingleTaskState {}

final class SingleTaskStateFailure extends SingleTaskState {
  final String message;

  SingleTaskStateFailure(this.message);
}


final class SingleTaskStateTaskUpdated extends SingleTaskState {
  final String taskId;

  SingleTaskStateTaskUpdated(this.taskId);
}

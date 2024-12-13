import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mimo/core/entity/task_entity.dart';
import 'package:mimo/core/utils/group_tasks.dart';
import 'package:mimo/features/tasks/domain/use%20cases/create_task.dart';
import 'package:mimo/features/tasks/domain/use%20cases/get_tasks.dart';
import 'package:mimo/features/tasks/domain/use%20cases/update_task.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final UseCaseGetTasks _useCaseGetTasks;
  final UseCaseCreateTask _useCaseCreateTask;

  TasksBloc({
    required UseCaseGetTasks useCaseGetTasks,
    required UseCaseCreateTask useCaseCreateTask,
  })  : _useCaseGetTasks = useCaseGetTasks,
        _useCaseCreateTask = useCaseCreateTask,
        super(TasksInitial()) {
    on<TasksEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<TasksEventGetTasks>(
        (event, emit) async => await _onTasksEventGetTasks(event, emit));

    on<TasksEventAddTask>(
        (event, emit) async => await _onTasksEventAddTask(event, emit));
  }

  Future _onTasksEventAddTask(
      TasksEventAddTask event, Emitter<TasksState> emit) async {
    emit(TasksStateLoading());
    final response = await _useCaseCreateTask(UseCaseCreateTaskParams(
      text: event.text,
      categoryId: event.categoryId,
      taskDate: event.taskDate,
      userId: event.userId,
    ));

    response.fold(
      (l) {
        log(l.message);
      },
      (r) {
        emit(TasksStateTaskAdded());
      },
    );
  }

  Future _onTasksEventGetTasks(
      TasksEventGetTasks event, Emitter<TasksState> emit) async {
    emit(TasksStateLoading());

    final response =
        await _useCaseGetTasks(UseCaseGetTasksParams(event.categoryId));

    response.fold(
      (l) {
        log(l.message);
        emit(TasksStateFailure(l.message));
      },
      (r) {
        emit(TasksStateTasks(groupTasksByDateAndSort(r)));
      },
    );
  }
}

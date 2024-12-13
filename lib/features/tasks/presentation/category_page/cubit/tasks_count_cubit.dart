import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mimo/features/tasks/domain/use%20cases/get_tasks_count.dart';

part 'tasks_count_state.dart';

class TasksCountCubit extends Cubit<TasksCountState> {
  final UseCaseGetTasksCount _useCaseGetTasksCount;

  TasksCountCubit({
    required UseCaseGetTasksCount useCaseGetTasksCount,
  })  : _useCaseGetTasksCount = useCaseGetTasksCount,
        super(TasksCountInitial());

  Future getTasksCount(String categoryId) async {
    final response =
        await _useCaseGetTasksCount(UseCaseGetTasksCountParams(categoryId));

    response.fold(
      (l) {
        log(l.message);
        emit(TasksCountStateTasksCount(categoryId: categoryId, count: 0));
      },
      (r) {
        emit(TasksCountStateTasksCount(categoryId: categoryId, count: r));
      },
    );
  }
}

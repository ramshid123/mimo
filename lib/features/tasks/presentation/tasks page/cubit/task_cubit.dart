import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mimo/features/tasks/domain/use%20cases/update_task.dart';

part 'task_state.dart';

class SingleTaskCubit extends Cubit<SingleTaskState> {
  final UseCaseUpdateTask _useCaseUpdateTask;

  SingleTaskCubit({
    required UseCaseUpdateTask useCaseUpdateTask,
  })  : _useCaseUpdateTask = useCaseUpdateTask,
        super(SingleTaskInitial());

  Future changeBoolValue({required String taskId, required bool value}) async {
    {
      final response = await _useCaseUpdateTask(
          UseCaseUpdateTaskParams(taskId: taskId, value: value));

      response.fold(
        (l) {
          log(l.message);
          emit(SingleTaskStateFailure(l.message));
        },
        (r) {
          emit(SingleTaskStateTaskUpdated(r));
        },
      );
    }
  }
}

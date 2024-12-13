import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mimo/core/entity/task_entity.dart';
import 'package:mimo/core/theme/palette.dart';
import 'package:mimo/core/widgets/common.dart';
import 'package:mimo/core/widgets/custom_checkbox.dart';
import 'package:mimo/features/tasks/presentation/tasks%20page/bloc/tasks_bloc.dart';
import 'package:mimo/features/tasks/presentation/tasks%20page/cubit/task_cubit.dart';

class TasksPageWidgets {
  static Widget _taskItem({
    required TaskEntity task,
    required BuildContext context,
    required ValueNotifier<bool> isCompleted,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomCheckBox(
          value: isCompleted.value,
          onChanged: (v) {
            context
                .read<SingleTaskCubit>()
                .changeBoolValue(taskId: task.taskId, value: v);
          },
          checkedIconColor: Theme.of(context).scaffoldBackgroundColor,
          uncheckedIconColor: Theme.of(context).scaffoldBackgroundColor,
          uncheckedFillColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        kWidth(5),
        kText(
          text: task.taskText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          maxLines: 5,
        ),
      ],
    );
  }

  static Widget taskForDayItem(MapEntry<String, List<TaskEntity>> task) {
    return Builder(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: kText(
              text: task.key,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .color!
                  .withOpacity(0.5),
            ),
          ),
          kHeight(5),
          for (int i = 0; i < task.value.length; i++)
            Builder(builder: (context) {
              final isCompleted = ValueNotifier(task.value[i].isCompleted);

              return BlocListener<SingleTaskCubit, SingleTaskState>(
                listener: (context, state) {
                  if (state is SingleTaskStateTaskUpdated) {
                    if (state.taskId == task.value[i].taskId) {
                      isCompleted.value = !isCompleted.value;
                    }
                  }
                },
                child: ValueListenableBuilder(
                  valueListenable: isCompleted,
                  builder: (context, _, __) {
                    return _taskItem(
                      task: task.value[i],
                      context: context,
                      isCompleted: isCompleted,
                    );
                  },
                ),
              );
            }),
          kHeight(20),
        ],
      );
    });
  }

  static Widget addCategoryPopup(
      {required String userId, required String categoryId}) {
    return _AddTaskPopup(
      categoryId: categoryId,
      userId: userId,
    );
  }
}

class _AddTaskPopup extends StatefulWidget {
  final String categoryId;
  final String userId;
  const _AddTaskPopup(
      {super.key, required this.categoryId, required this.userId});

  @override
  State<_AddTaskPopup> createState() => __AddTaskPopupState();
}

class __AddTaskPopupState extends State<_AddTaskPopup> {
  final showButton = ValueNotifier(false);

  final taskTextController = TextEditingController();
  final taskDate = ValueNotifier(DateTime.now());
  // ValueNotifier(DateFormat('EEEE, MMM dd, yyyy').format(DateTime.now()));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Column(
            children: [
              kHeight(200),
              Material(
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            kWidth(double.infinity),
                            TextFormField(
                              controller: taskTextController,
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (v) {
                                if (taskTextController.text.isNotEmpty) {
                                  showButton.value = true;
                                } else {
                                  showButton.value = false;
                                }
                              },
                              decoration: InputDecoration(
                                filled: false,
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Type your task..',
                                hintStyle: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color!
                                      .withOpacity(0.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            kHeight(20),
                            GestureDetector(
                              onTap: () async {
                                final date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    lastDate:
                                        DateTime(DateTime.now().year + 1));
                                if (date != null) {
                                  taskDate.value = date;
                                }
                              },
                              child: Container(
                                child: ValueListenableBuilder(
                                    valueListenable: taskDate,
                                    builder: (context, _, __) {
                                      return Row(
                                        children: [
                                          kText(
                                            text:
                                                DateFormat('EEEE, MMM dd, yyyy')
                                                    .format(taskDate.value),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          const Spacer(),
                                          Icon(
                                            Icons.calendar_month,
                                            size: 20,
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                            ),
                            kHeight(20),
                            ValueListenableBuilder(
                                valueListenable: showButton,
                                builder: (context, _, __) {
                                  return Visibility(
                                    visible: showButton.value,
                                    child: GestureDetector(
                                      onTap: () {
                                        context
                                            .read<TasksBloc>()
                                            .add(TasksEventAddTask(
                                              text: taskTextController.text
                                                  .trim(),
                                              taskDate: taskDate.value,
                                              categoryId: widget.categoryId,
                                              userId: widget.userId,
                                            ));
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          color: ColorConstants.blue,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: kText(
                                            text: 'Add',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(10, -10),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

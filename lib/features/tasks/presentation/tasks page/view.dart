import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mimo/core/entity/user_entity.dart';
import 'package:mimo/core/global%20states/user%20state/bloc/user_bloc.dart';
import 'package:mimo/core/theme/palette.dart';
import 'package:mimo/core/widgets/common.dart';
import 'package:mimo/features/tasks/presentation/tasks%20page/bloc/tasks_bloc.dart';
import 'package:mimo/features/tasks/presentation/tasks%20page/widgets.dart';

class TasksPage extends StatefulWidget {
  final String categoryId;

  const TasksPage({super.key, required this.categoryId});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late UserEntity storedUserData;

  @override
  void initState() {
    // TODO: implement initState
    storedUserData =
        (context.read<UserBloc>().state as UserStateUserEntity).userEntity;
    // storedUserData = UserEntity(
    //   name: '',
    //   userId: 'v6f82hNemiU7xMxJhr9phJYrxSH2',
    //   email: '',
    //   profilePicUrl: '',
    //   location: '',
    //   description: '',
    // );
    context.read<TasksBloc>().add(TasksEventGetTasks(widget.categoryId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksBloc, TasksState>(
      listener: (context, state) {
        if (state is TasksStateTaskAdded) {
          Navigator.pop(context);
          context.read<TasksBloc>().add(TasksEventGetTasks(widget.categoryId));
        }
        // TODO: implement listener
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).textTheme.bodyMedium!.color,
          shape: CircleBorder(),
          child: Icon(
            Icons.add,
            size: 25,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          onPressed: () async {
            await showDialog(
              context: context,
              barrierColor: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .color!
                  .withOpacity(0.12),
              builder: (context) => TasksPageWidgets.addCategoryPopup(
                  userId: storedUserData.userId, categoryId: widget.categoryId),
            );
          },
        ),
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: kText(
            text: 'Sport',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.search,
                size: 30,
              ),
            ),
          ],
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: BlocBuilder<TasksBloc, TasksState>(
            builder: (context, state) {
              if (state is TasksStateTasks) {
                return state.groupedTasks.length > 0
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            kHeight(20),
                            for (var task in state.groupedTasks.entries)
                              TasksPageWidgets.taskForDayItem(task),
                          ],
                        ),
                      )
                    : Center(
                        child: kText(
                          text: 'No tasks yet!',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .color!
                              .withOpacity(0.5),
                        ),
                      );
              } else if (state is TasksStateLoading) {
                return Center(
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      color: ColorConstants.blue,
                    ),
                  ),
                );
              } else {
                return kText(
                  text: 'No Tasks',
                  color: Theme.of(context).textTheme.bodyMedium!.color!,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

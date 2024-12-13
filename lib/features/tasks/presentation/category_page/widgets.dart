import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mimo/core/entity/category_entity.dart';
import 'package:mimo/core/theme/palette.dart';
import 'package:mimo/core/widgets/common.dart';
import 'package:mimo/features/tasks/presentation/category_page/bloc/categories_bloc.dart';
import 'package:mimo/features/tasks/presentation/category_page/cubit/tasks_count_cubit.dart';
import 'package:mimo/features/tasks/presentation/tasks%20page/view.dart';

class CategoriesPageWidget {
  static Widget quoteContainer() {
    return Builder(builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.3),
              offset: const Offset(0, 0),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            // CircleAvatar(
            //   radius: 25,
            // ),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSil-Aoq-5Fb0tK0kg1y-_6J0TVpuDuWkiIxA&s',
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
            kWidth(20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  kText(
                    text: '"The memories is a shield and life helper"',
                    family: 'Courgette',
                    maxLines: 10,
                  ),
                  kHeight(5),
                  kText(
                    text: 'Tamim Al-Barghouti',
                    fontSize: 12,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .color!
                        .withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  static Widget addButton(
      {required BuildContext context, required String userId}) {
    return GestureDetector(
      onTap: () async {
        await showDialog(
          context: context,
          barrierColor:
              Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.12),
          builder: (context) => addCategoryPopup(userId),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.3),
              offset: const Offset(0, 0),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(context).textTheme.bodyMedium!.color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              color: Theme.of(context).scaffoldBackgroundColor,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  static Widget categoryItem({
    required BuildContext context,
    required CategoryEntity category,
  }) {
    context.read<TasksCountCubit>().getTasksCount(category.categoryId);
    final count = ValueNotifier(0);
    return BlocListener<TasksCountCubit, TasksCountState>(
      listener: (context, state) {
        if (state is TasksCountStateTasksCount) {
          if (state.categoryId == category.categoryId) {
            count.value = state.count;
          }
        }
      },
      child: GestureDetector(
        onTap: () async {
          // Navigator.pop(context);
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TasksPage(categoryId: category.categoryId)));
          if (context.mounted) {
            context
                .read<CategoriesBloc>()
                .add(CategoriesEventGetCategories(category.userId));
          }
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.3),
                offset: const Offset(0, 0),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    kText(
                      text: category.emoji,
                      fontSize: 20,
                    ),
                    kText(
                      text: category.title,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    ValueListenableBuilder(
                        valueListenable: count,
                        builder: (context, __, _) {
                          return kText(
                            text: '${count.value} tasks',
                            fontSize: 14,
                          );
                        }),
                  ],
                ),
              ),
              const Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 5, bottom: 5),
                  child: Icon(
                    Icons.more_vert,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget addCategoryPopup(String userId) {
    return _AddCategoryPopup(
      userId: userId,
    );
  }
}

class _AddCategoryPopup extends StatefulWidget {
  final String userId;
  const _AddCategoryPopup({required this.userId});

  @override
  State<_AddCategoryPopup> createState() => _AddCategoryPopupState();
}

class _AddCategoryPopupState extends State<_AddCategoryPopup> {
  final showButton = ValueNotifier(false);

  final iconTextController = TextEditingController();

  final titleTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final focusNode = FocusNode();
    focusNode.requestFocus();
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
                  margin: const EdgeInsets.symmetric(horizontal: 40),
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
                              controller: iconTextController,
                              focusNode: focusNode,
                              style: GoogleFonts.nunito(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (v) {
                                if (iconTextController.text.isNotEmpty &&
                                    titleTextController.text.isNotEmpty) {
                                  showButton.value = true;
                                } else {
                                  showButton.value = false;
                                }
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: '🏠',
                                hintStyle: GoogleFonts.nunito(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                                filled: false,
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            // kText(
                            //   text: 'Title',
                            //   fontSize: 25,
                            //   color: Theme.of(context).textTheme.bodyMedium!.color.withOpacity(0.5),
                            //   fontWeight: FontWeight.bold,
                            // ),
                            TextFormField(
                              controller: titleTextController,
                              onChanged: (v) {
                                if (iconTextController.text.isNotEmpty &&
                                    titleTextController.text.isNotEmpty) {
                                  showButton.value = true;
                                } else {
                                  showButton.value = false;
                                }
                              },
                              style: GoogleFonts.nunito(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Title',
                                hintStyle: GoogleFonts.nunito(
                                  fontSize: 25,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color!
                                      .withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                ),
                                filled: false,
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            kText(
                              text: '0 task',
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color!
                                  .withOpacity(0.5),
                              fontSize: 20,
                            ),
                            kHeight(20),
                            ValueListenableBuilder(
                                valueListenable: showButton,
                                builder: (context, _, __) {
                                  return Visibility(
                                    visible: showButton.value,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        context.read<CategoriesBloc>().add(
                                            CategoriesEventAddCategory(
                                                title: titleTextController.text
                                                    .trim(),
                                                emoji: iconTextController.text
                                                    .trim(),
                                                userId: widget.userId));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
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
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
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
                        offset: const Offset(10, -10),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(5),
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

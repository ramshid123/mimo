import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mimo/core/entity/user_entity.dart';
import 'package:mimo/core/global%20states/user%20state/bloc/user_bloc.dart';
import 'package:mimo/core/theme/palette.dart';
import 'package:mimo/core/widgets/common.dart';
import 'package:mimo/features/auth/presentation/settings_page/view.dart';
import 'package:mimo/features/tasks/presentation/category_page/bloc/categories_bloc.dart';
import 'package:mimo/features/tasks/presentation/category_page/widgets.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late UserEntity storedUserData;

  @override
  void initState() {
    // TODO: implement initState
    storedUserData =
        (context.read<UserBloc>().state as UserStateUserEntity).userEntity;

    context
        .read<CategoriesBloc>()
        .add(CategoriesEventGetCategories(storedUserData.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoriesBloc, CategoriesState>(
      listener: (context, state) {
        if (state is CategoriesStateCategoryAdded) {
          context
              .read<CategoriesBloc>()
              .add(CategoriesEventGetCategories(storedUserData.userId));
        }
        // TODO: implement listener
      },
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SettingsPage()));
                      // context.read<UserBloc>().add(UserEventUserUpdate(userEntity))
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          String picUrl = storedUserData.profilePicUrl;
                          if (state is UserStateUserEntity) {
                            picUrl = state.userEntity.profilePicUrl;
                            log(picUrl);
                          }
                          return Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            child: storedUserData.profilePicUrl.isEmpty &&
                                    picUrl.isEmpty
                                ? Icon(
                                    Icons.person_rounded,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    size: 20,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: Image.network(
                                      picUrl,
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                  kText(
                    text: 'Categories',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.search,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      kHeight(40),
                      CategoriesPageWidget.quoteContainer(),
                      kHeight(40),
                      BlocBuilder<CategoriesBloc, CategoriesState>(
                        builder: (context, state) {
                          if (state is CategoriesStateCategories) {
                            return state.categories.isNotEmpty
                                ? LayoutGrid(
                                    columnSizes: [1.fr, 1.fr],
                                    rowSizes: [
                                      for (int i = 0;
                                          i < state.categories.length;
                                          i++)
                                        auto
                                    ],
                                    rowGap: 20,
                                    columnGap: 20,
                                    children: [
                                      CategoriesPageWidget.addButton(
                                          context: context,
                                          userId: storedUserData.userId),
                                      for (int i = 0;
                                          i < state.categories.length;
                                          i++)
                                        CategoriesPageWidget.categoryItem(
                                          context: context,
                                          category: state.categories[i],
                                        ),
                                    ],
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      await showDialog(
                                          context: context,
                                          barrierColor: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color!
                                              .withOpacity(0.26),
                                          builder: (context) =>
                                              CategoriesPageWidget
                                                  .addCategoryPopup(
                                                      storedUserData.userId));
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Column(
                                        children: [
                                          kHeight(100),
                                          kText(
                                            text: 'No Categories yet!',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .color!
                                                .withOpacity(0.5),
                                          ),
                                          kHeight(10),
                                          Icon(
                                            Icons.add,
                                            size: 30,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .color!
                                                .withOpacity(0.5),
                                          ),
                                          kHeight(100),
                                        ],
                                      ),
                                    ),
                                  );
                          } else if (state is CategoriesStateLoading) {
                            return Container(
                              margin: EdgeInsets.only(top: 200),
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(
                                color: ColorConstants.blue,
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mimo/core/global%20states/user%20state/bloc/user_bloc.dart';

import 'package:mimo/core/theme/palette.dart';
import 'package:mimo/core/theme/theme.dart';
import 'package:mimo/features/auth/presentation/auth_page/forgot_pass_page.dart';
import 'package:mimo/features/auth/presentation/auth_page/login_page.dart';
import 'package:mimo/features/auth/presentation/auth_page/signup_page.dart';
import 'package:mimo/features/auth/presentation/edit_profile_page/cubit/edit_profile_cubit.dart';
import 'package:mimo/features/auth/presentation/auth_page/bloc/login_bloc.dart';
import 'package:mimo/features/auth/presentation/settings_page/cubit/profile_pic_cubit.dart';
import 'package:mimo/features/auth/presentation/settings_page/cubit/settings_cubit.dart';
import 'package:mimo/features/auth/presentation/settings_page/view.dart';
import 'package:mimo/features/auth/presentation/splash_screen/cubit/user_auth_cubit.dart';

import 'package:mimo/features/auth/presentation/splash_screen/view.dart';
import 'package:mimo/features/tasks/presentation/category_page/bloc/categories_bloc.dart';
import 'package:mimo/features/tasks/presentation/category_page/cubit/tasks_count_cubit.dart';
import 'package:mimo/features/tasks/presentation/category_page/view.dart';
import 'package:mimo/features/tasks/presentation/tasks%20page/bloc/tasks_bloc.dart';
import 'package:mimo/features/tasks/presentation/tasks%20page/cubit/task_cubit.dart';
import 'package:mimo/features/tasks/presentation/tasks%20page/view.dart';
import 'package:mimo/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [
      SystemUiOverlay.top,
    ],
  );

  await initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => serviceLocator()),
        BlocProvider<UserAuthCubit>(create: (_) => serviceLocator()),
        BlocProvider<SettingsCubit>(create: (_) => serviceLocator()),
        BlocProvider<EditProfileCubit>(create: (_) => serviceLocator()),
        BlocProvider<UserBloc>(create: (_) => serviceLocator()),
        BlocProvider<CategoriesBloc>(create: (_) => serviceLocator()),
        BlocProvider<TasksBloc>(create: (_) => serviceLocator()),
        BlocProvider<SingleTaskCubit>(create: (_) => serviceLocator()),
        BlocProvider<TasksCountCubit>(create: (_) => serviceLocator()),
        BlocProvider<ProfilePicCubit>(create: (_) => serviceLocator()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme(),
        darkTheme: darkTheme().copyWith(),
        themeMode: ThemeMode.system,
        title: 'Mimo',
        home: const SplashScreen(),
        // home: MyCoursesPage(),
      ),
    );
  }
}

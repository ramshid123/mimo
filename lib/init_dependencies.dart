import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:mimo/core/global%20states/user%20state/bloc/user_bloc.dart';
import 'package:mimo/features/auth/data/data%20source/auth_data_service.dart';
import 'package:mimo/features/auth/data/data%20source/auth_data_source.dart';
import 'package:mimo/features/auth/data/data%20source/storage_service.dart';
import 'package:mimo/features/auth/data/repository/auth_repository.dart';
import 'package:mimo/features/auth/data/repository/storage_repository.dart';
import 'package:mimo/features/auth/domain/repository/auth_repository.dart';
import 'package:mimo/features/auth/domain/repository/storage_repository.dart';
import 'package:mimo/features/auth/domain/usecases/get_current_uid.dart';
import 'package:mimo/features/auth/domain/usecases/login.dart';
import 'package:mimo/features/auth/domain/usecases/logout.dart';
import 'package:mimo/features/auth/domain/usecases/send_reset_pass_email.dart';
import 'package:mimo/features/auth/domain/usecases/signup.dart';
import 'package:mimo/features/auth/domain/usecases/update_user_data.dart';
import 'package:mimo/features/auth/domain/usecases/upload_profile_pic.dart';
import 'package:mimo/features/auth/presentation/auth_page/bloc/login_bloc.dart';
import 'package:mimo/features/auth/presentation/edit_profile_page/cubit/edit_profile_cubit.dart';
import 'package:mimo/features/auth/presentation/settings_page/cubit/profile_pic_cubit.dart';
import 'package:mimo/features/auth/presentation/settings_page/cubit/settings_cubit.dart';
import 'package:mimo/features/auth/presentation/splash_screen/cubit/user_auth_cubit.dart';
import 'package:mimo/features/tasks/data/data%20source/remote_data_source.dart';
import 'package:mimo/features/tasks/data/repository/repository.dart';
import 'package:mimo/features/tasks/domain/repository/repository.dart';
import 'package:mimo/features/tasks/domain/use%20cases/create_category.dart';
import 'package:mimo/features/tasks/domain/use%20cases/create_task.dart';
import 'package:mimo/features/tasks/domain/use%20cases/get_categories.dart';
import 'package:mimo/features/tasks/domain/use%20cases/get_tasks.dart';
import 'package:mimo/features/tasks/domain/use%20cases/get_tasks_count.dart';
import 'package:mimo/features/tasks/domain/use%20cases/update_task.dart';
import 'package:mimo/features/tasks/presentation/category_page/bloc/categories_bloc.dart';
import 'package:mimo/features/tasks/presentation/category_page/cubit/tasks_count_cubit.dart';
import 'package:mimo/features/tasks/presentation/tasks%20page/bloc/tasks_bloc.dart';
import 'package:mimo/features/tasks/presentation/tasks%20page/cubit/task_cubit.dart';

import 'package:appwrite/appwrite.dart';
import 'package:mimo/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future initDependencies() async {
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Client client = Client();
  client.setProject(dotenv.env['APPWRITE_PROJECT_ID']!);

  Storage storage = Storage(client);

  final FirebaseFirestore firebaseDb = FirebaseFirestore.instance;
  final SharedPreferences sharedPreferencesInstance =
      await SharedPreferences.getInstance();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  serviceLocator
    ..registerLazySingleton(() => firebaseDb)
    ..registerLazySingleton(() => sharedPreferencesInstance)
    ..registerLazySingleton(() => firebaseAuth)
    ..registerLazySingleton(() => client)
    ..registerLazySingleton(() => storage);

  _initLearning();

  firebaseAuth.userChanges().listen((user) {
    if (user == null) {
    } else {}
  });
}

void _initLearning() {
  serviceLocator
        ..registerFactory<AuthService>(() => AuthServiceImpl(serviceLocator()))
        ..registerFactory<AuthDataSource>(
            () => AuthDataSourceImpl(serviceLocator()))
        ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(
            authService: serviceLocator(), authDataSource: serviceLocator()))
        ..registerFactory<TasksRemoteSource>(
            () => TasksRemoteSourceImpl(serviceLocator()))
        ..registerFactory<TaskRepository>(
            () => TaskRepositoryImpl(serviceLocator()))
        ..registerFactory<StorageService>(
            () => StorageServiceImpl(serviceLocator()))
        ..registerFactory<StorageRepository>(
            () => StorageRepositoryImpl(serviceLocator()))
        ..registerFactory(() => UseCaseGetCurrentUid(serviceLocator()))
        ..registerFactory(() => UseCaseUpdateUserData(serviceLocator()))
        ..registerFactory(() => UseCaseResetPasswordEmail(serviceLocator()))
        ..registerFactory(() => UseCaseLogin(serviceLocator()))
        ..registerFactory(() => UseCaseLogout(serviceLocator()))
        ..registerFactory(() => UseCaseCreateCategory(serviceLocator()))
        ..registerFactory(() => UseCaseCreateTask(serviceLocator()))
        ..registerFactory(() => UseCaseUpdateTask(serviceLocator()))
        ..registerFactory(() => UseCaseGetCategories(serviceLocator()))
        ..registerFactory(() => UseCaseGetTasks(serviceLocator()))
        ..registerFactory(() => UseCaseUploadProfilepic(serviceLocator()))
        ..registerFactory(() => UseCaseGetTasksCount(serviceLocator()))
        ..registerFactory(() => UseCaseSignup(serviceLocator()))
        ..registerLazySingleton(
            () => UserAuthCubit(useCaseGetCurrentUid: serviceLocator()))
        ..registerLazySingleton(() => SettingsCubit(
              useCaseLogout: serviceLocator(),
              useCaseUpdateUserData: serviceLocator(),
            ))
        ..registerLazySingleton(
            () => EditProfileCubit(useCaseUpdateUserData: serviceLocator()))
        ..registerLazySingleton(() => UserBloc())
        ..registerLazySingleton(() => LoginBloc(
              useCaseLogin: serviceLocator(),
              useCaseResetPasswordEmail: serviceLocator(),
              useCaseSignup: serviceLocator(),
            ))
        ..registerLazySingleton(() => CategoriesBloc(
              useCaseCreateCategory: serviceLocator(),
              useCaseGetCategories: serviceLocator(),
            ))
        ..registerLazySingleton(() => TasksBloc(
              useCaseGetTasks: serviceLocator(),
              useCaseCreateTask: serviceLocator(),
            ))
        ..registerLazySingleton(
            () => SingleTaskCubit(useCaseUpdateTask: serviceLocator()))
        ..registerLazySingleton(
            () => TasksCountCubit(useCaseGetTasksCount: serviceLocator()))
        ..registerLazySingleton(
            () => ProfilePicCubit(useCaseUploadProfilepic: serviceLocator()))

      //
      ;
}

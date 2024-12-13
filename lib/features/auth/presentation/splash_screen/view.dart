import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mimo/core/global%20states/user%20state/bloc/user_bloc.dart';
import 'package:mimo/core/theme/palette.dart';
import 'package:mimo/core/widgets/common.dart';
import 'package:mimo/features/auth/presentation/auth_page/login_page.dart';
import 'package:mimo/features/auth/presentation/settings_page/cubit/settings_cubit.dart';
import 'package:mimo/features/auth/presentation/splash_screen/cubit/user_auth_cubit.dart';
import 'package:mimo/features/tasks/presentation/category_page/view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    context.read<UserAuthCubit>().checkForLogin();
    // context.read<SettingsCubit>().logout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserAuthCubit, UserAuthState>(
      listener: (context, state) async {
        if (state is UserAuthStateResult) {
          await Future.delayed(const Duration(seconds: 1));
          if (state.user == null) {
            if (context.mounted) {
              await Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (_) => false);
            }
          } else {
            if (context.mounted) {
              context.read<UserBloc>().add(UserEventUserUpdate(state.user!));
              await Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoriesPage()),
                  (_) => false);
            }
          }

          // context.read<UserBloc>().add(event)
        }
      },
      child: Scaffold(
        body: Center(
          child: Image.asset(
            Theme.of(context).brightness == Brightness.light
                ? 'assets/mimo_light_sharp.png'
                : 'assets/mimo_dark_sharp.png',
            height: 60,
          ),
        ),
      ),
    );
  }
}

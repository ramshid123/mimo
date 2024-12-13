import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mimo/core/enum/login_form_types.dart';
import 'package:mimo/core/global%20states/user%20state/bloc/user_bloc.dart';
import 'package:mimo/core/theme/palette.dart';
import 'package:mimo/core/utils/show_toast.dart';
import 'package:mimo/core/widgets/common.dart';
import 'package:mimo/features/auth/presentation/auth_page/bloc/login_bloc.dart';
import 'package:mimo/features/auth/presentation/auth_page/forgot_pass_page.dart';
import 'package:mimo/features/auth/presentation/auth_page/signup_page.dart';
import 'package:mimo/features/auth/presentation/auth_page/widgets.dart';
import 'package:mimo/features/tasks/presentation/category_page/view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final actionIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginStateFailure) {
          showToastMessage(
            context: context,
            message: state.errormsg,
          );
        } else if (state is LoginStateSuccess) {
          showToastMessage(context: context, message: 'Login Success');
          context.read<UserBloc>().add(UserEventUserUpdate(state.user));
          Future.delayed(const Duration(seconds: 1), () async {
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoriesPage()),
                  (_) => false);
            }
          });
        }
      },
      child: ValueListenableBuilder(
          valueListenable: actionIndex,
          builder: (context, _, __) {
            return PopScope(
              onPopInvokedWithResult: (didPop, result) async {},
              canPop: actionIndex.value == 0,
              child: Scaffold(
                body: Stack(
                  children: [
                    SingleChildScrollView(
                      child: SizedBox(
                        height: size.height,
                        child: SafeArea(
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      kHeight(200),
                                      // kText(
                                      //   text: 'Mimo',
                                      // ),
                                      Image.asset(
                                        Theme.of(context).brightness ==
                                                Brightness.light
                                            ? 'assets/mimo_light_sharp.png'
                                            : 'assets/mimo_dark_sharp.png',
                                        height: 60,
                                      ),
                                      kHeight(50),
                                      LoginPageWidgets.loginForm(
                                          hintText: 'Email',
                                          textController: emailController,
                                          loginFormType: LoginFormType.email),
                                      kHeight(20),
                                      LoginPageWidgets.loginForm(
                                          hintText: 'Password',
                                          textController: passwordController,
                                          loginFormType:
                                              LoginFormType.password),
                                      kHeight(10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: GestureDetector(
                                          onTap: () async {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ForgotPassPage()));
                                          },
                                          child: Container(
                                            child: kText(
                                              text: 'Forgot Password?',
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      kHeight(25),
                                      GestureDetector(
                                        onTap: () =>
                                            context.read<LoginBloc>().add(
                                                  LoginEventLogin(
                                                    email: emailController.text
                                                        .trim(),
                                                    password:
                                                        passwordController.text,
                                                  ),
                                                ),
                                        child:
                                            LoginPageWidgets.continueButton(),
                                      ),
                                      kHeight(30),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          kText(
                                            text: 'Don\'t have an account? ',
                                            fontSize: 13,
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SignupPage())),
                                            child: Container(
                                              child: kText(
                                                text: 'Register',
                                                underLine: true,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .color,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        if (state is LoginStateLoading) {
                          return Container(
                            height: size.height,
                            width: size.width,
                            color: ColorConstants.blue.withOpacity(0.5),
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const CircularProgressIndicator(
                                  color: ColorConstants.blue,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

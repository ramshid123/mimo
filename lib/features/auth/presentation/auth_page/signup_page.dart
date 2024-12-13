import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mimo/core/enum/login_form_types.dart';
import 'package:mimo/core/global%20states/user%20state/bloc/user_bloc.dart';
import 'package:mimo/core/theme/palette.dart';
import 'package:mimo/core/utils/show_toast.dart';
import 'package:mimo/core/widgets/common.dart';
import 'package:mimo/features/auth/presentation/auth_page/bloc/login_bloc.dart';
import 'package:mimo/features/auth/presentation/auth_page/login_page.dart';
import 'package:mimo/features/auth/presentation/auth_page/widgets.dart';
import 'package:mimo/features/tasks/presentation/category_page/view.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: size.height,
                  child: SafeArea(
                    child: Column(
                      children: [
                        kHeight(200),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async =>
                                  await Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage())),
                              child: Container(
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 25,
                                ),
                              ),
                            ),
                            kText(
                              text: 'Create an Account',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            Opacity(
                              opacity: 0,
                              child: Icon(
                                Icons.arrow_back,
                                size: 25,
                              ),
                            )
                          ],
                        ),
                        kHeight(25),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              LoginPageWidgets.loginForm(
                                  hintText: 'Full Name',
                                  textController: nameController,
                                  loginFormType: LoginFormType.name),
                              kHeight(15),
                              LoginPageWidgets.loginForm(
                                  hintText: 'Email',
                                  textController: emailController,
                                  loginFormType: LoginFormType.email),
                              kHeight(15),
                              LoginPageWidgets.loginForm(
                                  hintText: 'Password',
                                  textController: passwordController,
                                  loginFormType: LoginFormType.password),
                              kHeight(15),
                              LoginPageWidgets.loginForm(
                                  hintText: 'Confirm Password',
                                  textController: confirmPasswordController,
                                  loginFormType: LoginFormType.password),
                              kHeight(30),
                              GestureDetector(
                                onTap: () => context
                                    .read<LoginBloc>()
                                    .add(LoginEventSignup(
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                      fullname: nameController.text.trim(),
                                      confirmPass:
                                          confirmPasswordController.text,
                                    )),
                                child: LoginPageWidgets.continueButton(),
                              ),
                              kHeight(30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  kText(
                                    text: 'Already hae an account? ',
                                    fontSize: 13,
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage())),
                                    child: Container(
                                      child: kText(
                                        text: 'Login',
                                        fontSize: 13,
                                        underLine: true,
                                        color: Theme.of(context).textTheme.bodyMedium!.color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                          color: Theme.of(context).textTheme.bodyMedium!.color,
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
            ),
          ],
        ),
      ),
    );
  }
}

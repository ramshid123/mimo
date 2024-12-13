import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mimo/core/enum/login_form_types.dart';
import 'package:mimo/core/theme/palette.dart';
import 'package:mimo/core/utils/show_toast.dart';
import 'package:mimo/core/widgets/common.dart';
import 'package:mimo/features/auth/presentation/auth_page/bloc/login_bloc.dart';
import 'package:mimo/features/auth/presentation/auth_page/login_page.dart';
import 'package:mimo/features/auth/presentation/auth_page/signup_page.dart';
import 'package:mimo/features/auth/presentation/auth_page/widgets.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginStateEmailSent) {
          showToastMessage(
              context: context,
              message: 'Email sent to you for resetting your password');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    kHeight(200),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async => await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage())),
                          child: Container(
                            child: Icon(
                              Icons.arrow_back,
                              size: 25,
                            ),
                          ),
                        ),
                        kText(
                          text: 'Forgot Password',
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          kHeight(30),
                          LoginPageWidgets.loginForm(
                              hintText: 'Email',
                              textController: emailController,
                              loginFormType: LoginFormType.email),
                          kHeight(10),
                          kText(
                            text:
                                'Enter the email address you used to create your account and we will email you a link to reset your password.',
                            maxLines: 10,
                            textAlign: TextAlign.center,
                            fontSize: 12,
                          ),
                          kHeight(30),
                          GestureDetector(
                            onTap: () {
                              context.read<LoginBloc>().add(
                                  LoginEventForgotPassword(
                                      emailController.text.trim()));
                            },
                            child: LoginPageWidgets.continueButton(),
                          ),
                          kHeight(35),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              kText(
                                text: 'Don\'t have an account? ',
                                fontSize: 13,
                              ),
                              GestureDetector(
                                onTap: () async =>
                                    await Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignupPage())),
                                child: Container(
                                  child: kText(
                                    text: 'Register',
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
            )
          ],
        ),
      ),
    );
  }
}

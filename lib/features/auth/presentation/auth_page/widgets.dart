import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mimo/core/enum/login_form_types.dart';
import 'package:mimo/core/theme/palette.dart';
import 'package:mimo/core/widgets/common.dart';

class LoginPageWidgets {
  static Widget loginForm({
    required String hintText,
    required TextEditingController textController,
    required LoginFormType loginFormType,
  }) {
    final focusNode = FocusNode();
    return Builder(
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF000000).withOpacity(0.3),
                offset: Offset(0, 0),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: TextFormField(
            controller: textController,
            focusNode: focusNode,
            keyboardType: loginFormType == LoginFormType.email
                ? TextInputType.emailAddress
                : loginFormType == LoginFormType.password
                    ? TextInputType.visiblePassword
                    : TextInputType.text,
            cursorColor: ColorConstants.blue,
            obscureText: loginFormType == LoginFormType.password,
            onTapOutside: (v) => focusNode.unfocus(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              hintText: hintText,
              hintStyle: GoogleFonts.nunito(
                fontSize: 15,
                color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),
              ),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
              focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
      }
    );
  }

  static Widget continueButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorConstants.blue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: kText(
          text: 'Continue',
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}


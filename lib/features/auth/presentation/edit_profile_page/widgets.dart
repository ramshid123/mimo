import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mimo/core/theme/palette.dart';
import 'package:mimo/core/widgets/common.dart';

class EditProfilePageWidgets {
  static Widget textFormFields({
    required TextEditingController textController,
    required String hintText,
    bool isNumber = false,
  }) {
    final focusNode = FocusNode();
    return Builder(
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              kText(
                text: hintText,
                color: ColorConstants.blue,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              TextFormField(
                focusNode: focusNode,
                keyboardType: isNumber ? TextInputType.number : null,
                maxLength: isNumber ? 10 : null,
                buildCounter: (context,
                    {required currentLength,
                    required isFocused,
                    required maxLength}) {
                  return null;
                },
                controller: textController,
                inputFormatters:
                    isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
                cursorColor: ColorConstants.blue,
                onTapOutside: (v) => focusNode.unfocus(),
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyMedium!.color!,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorConstants.blue.withOpacity(0.2),
                  hintText: hintText,
                  hintStyle: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.blue.withOpacity(0.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  static Widget dobSelector(
      {required ValueNotifier<String> dob, required BuildContext context}) {
    return Theme(
      data: ThemeData(
        datePickerTheme: DatePickerThemeData(
          backgroundColor: Theme.of(context).textTheme.bodyMedium!.color,
          dividerColor: ColorConstants.blue,
          dayOverlayColor: const WidgetStatePropertyAll(ColorConstants.blue),
          surfaceTintColor: ColorConstants.blue.withOpacity(0.1),
          yearOverlayColor: const WidgetStatePropertyAll(ColorConstants.blue),
        ), // Set your desired color
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kText(
              text: 'Date of birth',
              color: ColorConstants.blue,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            GestureDetector(
              onTap: () async =>
                  await _showCalendar(context: context, dob: dob),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorConstants.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ValueListenableBuilder(
                    valueListenable: dob,
                    builder: (context, _, __) {
                      return kText(
                        text: dob.value.isEmpty
                            ? 'Date of birth'
                            : DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse(dob.value)),
                        fontSize: 15,
                        color: dob.value.isEmpty
                            ? ColorConstants.blue.withOpacity(0.5)
                            : Theme.of(context).textTheme.bodyMedium!.color!,
                        fontWeight: dob.value.isEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future _showCalendar(
      {required BuildContext context,
      required ValueNotifier<String> dob}) async {
    dob.value = (await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      barrierDismissible: true,
      onDatePickerModeChange: (value) => false,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: DatePickerMode.year,
    ))
        .toString();
  }
}

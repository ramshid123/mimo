import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget kText({
  required String text,
  Color? color,
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.normal,
  int? maxLines,
  TextAlign textAlign = TextAlign.start,
  bool applyHorizontalSpace = true,
  bool underLine = false,
  String family = 'Nunito',
}) {
  return Builder(builder: (context) {
    color ??= Theme.of(context).textTheme.bodyMedium!.color;
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textHeightBehavior: TextHeightBehavior(
        applyHeightToFirstAscent: applyHorizontalSpace,
        applyHeightToLastDescent: applyHorizontalSpace,
      ),
      style: GoogleFonts.getFont(
        family,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: underLine ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  });
}

Widget kHeight(double height) {
  return SizedBox(height: height);
}

Widget kWidth(double width) {
  return SizedBox(width: width);
}

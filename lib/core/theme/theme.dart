import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xffffffff),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Color(0xff303244))),
    // Custom color defined here
    // extensions: <ThemeExtension<dynamic>>[
    //   CustomColors(
    //     containerColor: Colors.yellow, // Light mode custom color
    //   ),
    // ],
  );
}

ThemeData darkTheme() {
  return ThemeData(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xff2f3441),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Color(0xffffffff))),
    // extensions: <ThemeExtension<dynamic>>[
    //   CustomColors(
    //     containerColor: Colors.orange,
    //   ),
    // ],
  );
}

// class CustomColors extends ThemeExtension<CustomColors> {
//   final Color? containerColor;
//   final Color? buttonColor;
//   final Color? cardColor;

//   const CustomColors({this.containerColor, this.buttonColor, this.cardColor});

//   @override
//   CustomColors copyWith({
//     Color? containerColor,
//     Color? buttonColor,
//     Color? cardColor,
//   }) {
//     return CustomColors(
//       containerColor: containerColor ?? this.containerColor,
//       buttonColor: buttonColor ?? this.buttonColor,
//       cardColor: cardColor ?? this.cardColor,
//     );
//   }

//   @override
//   CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
//     if (other is! CustomColors) return this;
//     return CustomColors(
//       containerColor: Color.lerp(containerColor, other.containerColor, t),
//       buttonColor: Color.lerp(buttonColor, other.buttonColor, t),
//       cardColor: Color.lerp(cardColor, other.cardColor, t),
//     );
//   }
// }

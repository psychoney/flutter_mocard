import 'package:flutter/material.dart';
import 'package:mocard/configs/colors.dart';

import 'fonts.dart';

class Themings {
  static final TextStyle darkText = TextStyle(
    color: AppColors.whiteGrey,
    fontFamily: AppFonts.circularStd,
  );

  static final TextStyle lightText = TextStyle(
    color: AppColors.black,
    fontFamily: AppFonts.circularStd,
  );

  static final ThemeData darkTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: AppColors.darkGrey,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
        background: Colors.black12, secondary: Colors.blueAccent, brightness: Brightness.dark),
    textTheme: TextTheme(
      bodyLarge: darkText,
      bodyMedium: darkText,
      labelMedium: darkText,
      bodySmall: darkText,
      labelLarge: darkText,
      labelSmall: darkText,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return Colors.blue;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return Colors.blue;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return Colors.blue;
        }
        return null;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return Colors.blue;
        }
        return null;
      }),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.blue,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: AppColors.darkGrey),
      toolbarTextStyle: lightText,
    ),
    textTheme: TextTheme(
      bodyLarge: lightText,
      bodyMedium: lightText,
      labelMedium: lightText,
      bodySmall: lightText,
      labelLarge: lightText,
      labelSmall: lightText,
    ),
    scaffoldBackgroundColor: AppColors.lightGrey,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
        .copyWith(background: AppColors.whiteGrey),
  );
}

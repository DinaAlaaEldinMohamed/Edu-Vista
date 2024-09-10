import 'package:edu_vista/utils/colors_utils.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    fontFamily: "PlusJakartaSans",
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorUtility.primaryColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: ColorUtility.pageBackgroundColor,
    useMaterial3: true,
  );

  static final darkTheme = ThemeData(
    fontFamily: "PlusJakartaSans",
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorUtility.blackColor,
      primary: Colors.black,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: ColorUtility.blackColor,
    cardColor: Colors.black,
    useMaterial3: true,
  );
}

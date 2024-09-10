import 'package:edu_vista/utils/app_theme.dart';
import 'package:flutter/material.dart';

class ThemeNotifier extends ValueNotifier<ThemeData> {
  ThemeNotifier(super.value);

  void toggleTheme() {
    value = (value.brightness == Brightness.dark)
        ? AppThemes.lightTheme
        : AppThemes.darkTheme;
    notifyListeners();
  }
}

final themeNotifier = ThemeNotifier(AppThemes.lightTheme);

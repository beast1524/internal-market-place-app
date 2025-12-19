import 'package:flutter/material.dart';

class ThemeController {
  ThemeController._internal();

  static final ThemeController instance = ThemeController._internal();

  final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);

  void toggle() {
    mode.value = mode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isDark => mode.value == ThemeMode.dark;
}

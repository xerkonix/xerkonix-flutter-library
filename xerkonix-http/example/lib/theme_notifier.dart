import 'package:flutter/material.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

class ThemeNotifier extends InheritedWidget {
  ThemeNotifier({super.key, required super.child});
  final ValueNotifier<ThemeData> theme = ValueNotifier(XkLightTheme.themeData);

  void setLightMode() {
    theme.value = XkLightTheme.themeData;
  }

  void setDarkMode() {
    theme.value = XkDarkTheme.themeData;
  }

  static ThemeNotifier? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeNotifier>();


  void updateTheme(ThemeData theme) => this.theme.value = theme;

  @override
  bool updateShouldNotify(ThemeNotifier oldWidget) => oldWidget.theme != theme;
}

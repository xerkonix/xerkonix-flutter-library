import 'package:flutter/material.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

class ThemeViewModel extends InheritedWidget {
  ThemeViewModel({super.key, required super.child});
  final ValueNotifier<ThemeData> theme = ValueNotifier(XkLightTheme.themeData);

  void setLightMode() {
    theme.value = XkLightTheme.themeData;
  }

  void setDarkMode() {
    theme.value = XkDarkTheme.themeData;
  }

  static ThemeViewModel? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeViewModel>();

  void updateTheme(ThemeData theme) => this.theme.value = theme;

  @override
  bool updateShouldNotify(ThemeViewModel oldWidget) => oldWidget.theme != theme;
}

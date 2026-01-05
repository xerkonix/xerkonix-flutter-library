import 'package:example/home_page.dart';
import 'package:example/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';
import 'package:xerkonix_sizer/xerkonix_sizer.dart';

void main() {
  Sizer.init(standardLogicalWidth: 420, standardLogicalHeight: 920);
  runApp(ThemeViewModel(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ThemeViewModel.of(context)!.theme,
      builder: (BuildContext context, ThemeData themeData, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Xerkonix Sizer',
          theme: XkLightTheme.themeData,
          darkTheme: XkDarkTheme.themeData,
          themeMode: ThemeMode.light,
          home: const HomePage(),
        );
      },
    );
  }
}

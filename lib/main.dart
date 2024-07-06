import 'package:arcane/ui/screens/splash/splash_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arcane',
      theme: FlexThemeData.light(scheme: FlexScheme.tealM3),
      // The Mandy red, dark theme.
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.tealM3),
      // Use dark or light theme based on system setting.
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}

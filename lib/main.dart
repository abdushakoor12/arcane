import 'package:arcane/ui/screens/splash/splash_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      theme: getThemeData(false),
      darkTheme: getThemeData(true),
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }

  ThemeData getThemeData(bool isDark) {
    final theme = isDark
        ? FlexColorScheme.dark(scheme: FlexScheme.tealM3)
        : FlexColorScheme.light(scheme: FlexScheme.tealM3);
    return theme.toTheme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(theme.textTheme),
    );
  }
}

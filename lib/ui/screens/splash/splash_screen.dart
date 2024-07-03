import 'package:arcane/database/app_database.dart';
import 'package:arcane/ui/screens/home/home_screen.dart';
import 'package:arcane/ui/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      final database = ref.read(appDatabaseProvider);
      database.select(database.vaults).get().then((vaults) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                vaults.isEmpty ? const WelcomeScreen() : const HomeScreen()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

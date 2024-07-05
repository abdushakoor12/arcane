import 'package:arcane/database/app_database.dart';
import 'package:arcane/database/daos/vault_dao.dart';
import 'package:arcane/ui/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class WelcomeScreen extends HookConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vaultController = useTextEditingController();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Arcane!',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(
              'Enter the name of your vault to get started.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 300,
              child: TextField(
                controller: vaultController,
                autofocus: true,
                onSubmitted: (value) {
                  if (value.trim().isEmpty) return;

                  final vaultsDao = ref.read(vaultsDaoProvider);
                  vaultsDao.insertVault(value).then((_) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false,
                    );
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Vault Name',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

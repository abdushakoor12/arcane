import 'package:arcane/database/daos/folder_dao.dart';
import 'package:arcane/database/daos/vault_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddFolderDialog extends HookConsumerWidget {
  const AddFolderDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final currentVault = ref.watch(currentVaultProvider).asData?.value;

    void submitDialog() {
      if (currentVault == null) return;

      final folderName = nameController.text.trim();
      if (folderName.isNotEmpty) {
        ref
            .read(folderDaoProvider)
            .insertFolder(currentVault, folderName)
            .then((_) => Navigator.of(context).pop());
      }
    }

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                onSubmitted: (_) => submitDialog(),
                decoration: const InputDecoration(labelText: 'Folder Name'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  submitDialog();
                },
                child: const Text('Add Folder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:arcane/database/app_database.dart';
import 'package:arcane/database/daos/folder_dao.dart';
import 'package:arcane/database/daos/vault_dao.dart';
import 'package:arcane/ui/dialogs/add_folder_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentVaultFoldersProvider = StreamProvider<List<Folder>>((ref) {
  final folderDao = ref.watch(folderDaoProvider);
  final currentVault = ref.watch(currentVaultProvider).asData?.value;

  if (currentVault == null) return const Stream.empty();
  return folderDao.watchFolders(currentVault);
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentVaultValue = ref.watch(currentVaultProvider);
    final allFolders =
        ref.watch(currentVaultFoldersProvider).asData?.value ?? [];
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 250,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => const AddFolderDialog());
                          },
                          icon: const Icon(
                            Icons.create_new_folder,
                          ))
                    ],
                  ),
                ),
                Expanded(
                    child: ListView.separated(
                  itemBuilder: (context, index) {
                    final folder = allFolders[index];
                    return GestureDetector(
                      onSecondaryTapUp: (details) {
                        final offset = details.globalPosition;
                        final position = RelativeRect.fromLTRB(
                          offset.dx,
                          offset.dy,
                          MediaQuery.of(context).size.width - offset.dx,
                          MediaQuery.of(context).size.height - offset.dy,
                        );
                        final p = showMenu(
                          context: context,
                          position: position,
                          items: [
                            PopupMenuItem(
                              onTap: () => ref
                                  .read(folderDaoProvider)
                                  .deleteFolder(folder),
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(folder.title),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: allFolders.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      height: 1,
                    );
                  },
                )),
              ],
            ),
          ),
          const VerticalDivider(),
        ],
      ),
    );
  }
}

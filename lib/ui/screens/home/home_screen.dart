import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:arcane/database/app_database.dart';
import 'package:arcane/database/daos/folder_dao.dart';
import 'package:arcane/database/daos/vault_dao.dart';
import 'package:arcane/ui/dialogs/add_folder_dialog.dart';
import 'package:arcane/ui/screens/home/home_screen_notifier.dart';
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
    final allFolders =
        ref.watch(currentVaultFoldersProvider).asData?.value ?? [];
    final folderNodes = buildFolderNodes(allFolders);
    final expandedFoldersCount = ref.watch(
        homeScreenNotifierProvider.select((e) => e.expandedFolderIds.length));
    print(expandedFoldersCount);
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
                          )),
                      // IconButton(
                      //     onPressed: () {

                      //     },
                      //     icon: Icon(
                      //       expandedFoldersCount > 0
                      //           ? Icons.unfold_more
                      //           : Icons.unfold_less,
                      //     )),
                    ],
                  ),
                ),
                Expanded(
                    child: ListView.separated(
                  itemBuilder: (context, index) {
                    final folderTree = folderNodes[index];
                    return FolderTreeView(
                      folderNode: folderTree,
                      key: ValueKey(folderTree.folder.id),
                    );
                  },
                  itemCount: folderNodes.length,
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

class FolderTreeView extends ConsumerWidget {
  final FolderNode folderNode;
  const FolderTreeView({super.key, required this.folderNode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folder = folderNode.folder;
    final expandedList =
        ref.watch(homeScreenNotifierProvider).expandedFolderIds;
    final expanded = expandedList.contains(folder.id);
    return Column(
      children: [
        GestureDetector(
          onTapUp: (details) {
            ref
                .read(homeScreenNotifierProvider.notifier)
                .toggleFolder(folder.id);
          },
          onSecondaryTapUp: (details) {
            final offset = details.globalPosition;
            final position = RelativeRect.fromLTRB(
              offset.dx,
              offset.dy,
              MediaQuery.of(context).size.width - offset.dx,
              MediaQuery.of(context).size.height - offset.dy,
            );
            showMenu(
              context: context,
              position: position,
              items: [
                PopupMenuItem(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) =>
                          AddFolderDialog(parentFolder: folder)),
                  child: const Text('New Folder'),
                ),
                PopupMenuItem(
                  onTap: () => ref.read(folderDaoProvider).deleteFolder(folder),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
          child: Row(
            children: [
              const Icon(Icons.folder),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(folder.title),
                ),
              ),
              if (folderNode.children.isNotEmpty)
                Icon(
                  expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                ),
            ],
          ),
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Column(
              children: folderNode.children
                  .map((child) => FolderTreeView(
                        folderNode: child,
                        key: ValueKey(child.folder.id),
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class FolderNode {
  final Folder folder;
  List<FolderNode> children = [];
  Folder? parent;

  FolderNode({required this.folder});

  void setParent(Folder parent) {
    this.parent = parent;
  }

  void addChild(FolderNode child) {
    child.setParent(folder);
    children.add(child);
  }
}

List<FolderNode> buildFolderNodes(List<Folder> folders) {
  final folderMap = <String, FolderNode>{};

  for (final folder in folders) {
    folderMap[folder.id] = FolderNode(folder: folder);
  }

  final rootNodes = <FolderNode>[];

  for (final folder in folders) {
    final folderNode = folderMap[folder.id]!;

    if (folder.parentId != null) {
      // add as a child to its parent
      final parent = folderMap[folder.parentId!];
      parent?.addChild(folderNode);
    } else {
      // add as a root node
      rootNodes.add(folderNode);
    }
  }

  return rootNodes;
}

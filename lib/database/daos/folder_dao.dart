import 'package:arcane/database/app_database.dart';
import 'package:arcane/database/utils/unique_id.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final folderDaoProvider =
    Provider((ref) => FolderDao(ref.watch(appDatabaseProvider)));

class FolderDao {
  final AppDatabase _appDatabase;

  FolderDao(this._appDatabase);

  Future<int> insertFolder(Vault vault, String title) {
    return _appDatabase.into(_appDatabase.folders).insert(
        FoldersCompanion.insert(
            id: getUniqueId(), title: title, vaultId: vault.id));
  }

  Stream<List<Folder>> watchFolders(Vault vault) {
    return (_appDatabase.select(_appDatabase.folders)
          ..where((t) => t.vaultId.equals(vault.id)))
        .watch();
  }

  Future<int> deleteFolder(Folder folder) {
    return _appDatabase.delete(_appDatabase.folders).delete(folder);
  }
}

import 'package:arcane/database/app_database.dart';
import 'package:arcane/database/utils/unique_id.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final vaultsDaoProvider =
    Provider((ref) => VaultDao(ref.watch(appDatabaseProvider)));

final currentVaultProvider = FutureProvider<Vault?>((ref) async {
  final vaultsDao = ref.watch(vaultsDaoProvider);
  final vaults = await vaultsDao.getAllVaults();
  return vaults.isEmpty ? null : vaults.first;
});

class VaultDao {
  final AppDatabase _appDatabase;

  VaultDao(this._appDatabase);

  Future<List<Vault>> getAllVaults() =>
      _appDatabase.select(_appDatabase.vaults).get();

  Stream<List<Vault>> watchAllVaults() =>
      _appDatabase.select(_appDatabase.vaults).watch();

  Future<int> insertVault(String value) {
    return _appDatabase.into(_appDatabase.vaults).insert(
          VaultsCompanion.insert(id: getUniqueId(), title: value),
        );
  }
}

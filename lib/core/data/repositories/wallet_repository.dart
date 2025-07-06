import 'package:drift/drift.dart';
import '../database.dart';

class WalletRepository {
  final FinanceDatabase _database;

  WalletRepository(this._database);

  /// Получить все кошельки
  Stream<List<WalletDbModel>> getAllWallets() {
    return _database.getAllWallets();
  }

  /// Получить кошелек по ID
  Future<WalletDbModel?> getWalletById(int id) async {
    final query = _database.select(_database.walletTable)
      ..where((w) => w.id.equals(id));
    return await query.getSingleOrNull();
  }

  /// Создать новый кошелек
  Future<int> createWallet(WalletTableCompanion wallet) async {
    return await _database.into(_database.walletTable).insert(wallet);
  }

  /// Обновить кошелек
  Future<bool> updateWallet(WalletTableCompanion wallet) async {
    return await _database.update(_database.walletTable).replace(wallet);
  }

  /// Удалить кошелек
  Future<int> deleteWallet(int id) async {
    return await (_database.delete(_database.walletTable)
          ..where((w) => w.id.equals(id)))
        .go();
  }

  /// Обновить баланс кошелька
  Future<int> updateBalance(int id, String newBalance) async {
    return await (_database.update(_database.walletTable)
          ..where((w) => w.id.equals(id)))
        .write(WalletTableCompanion(balance: Value(newBalance)));
  }

  /// Обновить название кошелька
  Future<int> updateName(int id, String newName) async {
    return await (_database.update(_database.walletTable)
          ..where((w) => w.id.equals(id)))
        .write(WalletTableCompanion(name: Value(newName)));
  }

  /// Обновить валюту кошелька
  Future<int> updateCurrency(int id, String newCurrency) async {
    return await (_database.update(_database.walletTable)
          ..where((w) => w.id.equals(id)))
        .write(WalletTableCompanion(currency: Value(newCurrency)));
  }
}

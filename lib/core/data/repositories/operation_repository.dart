import 'package:drift/drift.dart';
import '../database.dart';

class OperationRepository {
  final FinanceDatabase _database;

  OperationRepository(this._database);

  /// Получить все операции
  Stream<List<OperationDbModel>> getAllOperations() {
    return _database.getAllOperations();
  }

  /// Получить операции по кошельку
  Stream<List<OperationDbModel>> getOperationsByWallet(int walletId) {
    return _database.getOperationsByWallet(walletId);
  }

  /// Получить операцию по ID
  Future<OperationDbModel?> getOperationById(int id) async {
    final query = _database.select(_database.operationTable)
      ..where((o) => o.id.equals(id));
    return await query.getSingleOrNull();
  }

  /// Создать новую операцию
  Future<int> createOperation(OperationTableCompanion operation) async {
    return await _database.into(_database.operationTable).insert(operation);
  }

  /// Обновить операцию
  Future<bool> updateOperation(OperationTableCompanion operation) async {
    return await _database.update(_database.operationTable).replace(operation);
  }

  /// Удалить операцию
  Future<int> deleteOperation(int id) async {
    return await (_database.delete(_database.operationTable)
          ..where((o) => o.id.equals(id)))
        .go();
  }

  /// Получить операции за период
  Stream<List<OperationDbModel>> getOperationsByDateRange(
      DateTime start, DateTime end) {
    return (_database.select(_database.operationTable)
          ..where((o) =>
              o.operationDate.isBiggerOrEqualValue(start) &
              o.operationDate.isSmallerOrEqualValue(end)))
        .watch();
  }

  /// Получить операции по группе
  Stream<List<OperationDbModel>> getOperationsByGroup(int groupId) {
    return (_database.select(_database.operationTable)
          ..where((o) => o.groupId.equals(groupId)))
        .watch();
  }

  /// Удалить все операции
  Future<void> deleteAllOperations() async {
    await _database.delete(_database.operationTable).go();
  }

  /// Массово вставить операции
  Future<void> insertOperations(
      List<OperationTableCompanion> operations) async {
    await _database.batch((batch) {
      batch.insertAll(_database.operationTable, operations);
    });
  }
}

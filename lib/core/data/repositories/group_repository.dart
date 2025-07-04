import 'package:drift/drift.dart';
import '../database.dart';

class GroupRepository {
  final FinanceDatabase _database;

  GroupRepository(this._database);

  /// Получить все группы
  Stream<List<GroupDbModel>> getAllGroups() {
    return _database.getAllGroups();
  }

  /// Получить группу по ID
  Future<GroupDbModel?> getGroupById(int id) async {
    final query = _database.select(_database.groupTable)
      ..where((g) => g.id.equals(id));
    return await query.getSingleOrNull();
  }

  /// Создать новую группу
  Future<int> createGroup(GroupTableCompanion group) async {
    return await _database.into(_database.groupTable).insert(group);
  }

  /// Обновить группу
  Future<bool> updateGroup(GroupTableCompanion group) async {
    return await _database.update(_database.groupTable).replace(group);
  }

  /// Удалить группу
  Future<int> deleteGroup(int id) async {
    return await (_database.delete(_database.groupTable)
          ..where((g) => g.id.equals(id)))
        .go();
  }

  /// Получить группы по типу (доход/расход)
  Stream<List<GroupDbModel>> getGroupsByType(bool isIncome) {
    return (_database.select(_database.groupTable)
          ..where((g) => g.isIncome.equals(isIncome)))
        .watch();
  }

  /// Получить группы по названию (поиск)
  Stream<List<GroupDbModel>> searchGroups(String query) {
    return (_database.select(_database.groupTable)
          ..where((g) => g.name.like('%$query%')))
        .watch();
  }
}

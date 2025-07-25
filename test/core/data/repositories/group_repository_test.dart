import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shmr_25/core/data/repositories/group_repository.dart';
import 'package:shmr_25/core/data/database.dart';
import 'package:drift/drift.dart';
import 'package:mockito/annotations.dart';
import 'group_repository_test.mocks.dart' show MockFinanceDatabase, Mock$GroupTableTable, MockInsertStatement, MockUpdateStatement, MockDeleteStatement, MockGroupSimpleSelectStatement;

@GenerateMocks([
  FinanceDatabase,
  $GroupTableTable,
  UpdateStatement,
  DeleteStatement,
  InsertStatement,
], customMocks: [
  MockSpec<SimpleSelectStatement<$GroupTableTable, GroupDbModel>>(as: #MockGroupSimpleSelectStatement),
])
void main() {
  late MockFinanceDatabase db;
  late Mock$GroupTableTable groupTable;
  late GroupRepository repo;

  setUp(() {
    db = MockFinanceDatabase();
    groupTable = Mock$GroupTableTable();
    when(db.groupTable).thenReturn(groupTable);
    repo = GroupRepository(db);
  });

  group('GroupRepository', () {
    test('getAllGroups returns stream from db', () {
      when(db.getAllGroups()).thenAnswer((_) => Stream.value([]));
      expect(repo.getAllGroups(), emits(isA<List<GroupDbModel>>()));
    });

    test('getGroupById returns group if found', () async {
      final group = const GroupDbModel(
          id: 2, apiId: 2, name: 'Food', emoji: '🍔', isIncome: false);
      final mockSelect = MockGroupSimpleSelectStatement();
      when(db.select(groupTable)).thenReturn(mockSelect);
      when(mockSelect.where(any)).thenReturn(mockSelect);
      when(mockSelect.getSingleOrNull()).thenAnswer((_) async => group);
      final result = await repo.getGroupById(2);
      expect(result, group);
    });

    test('createGroup inserts group and returns id', () async {
      final companion = GroupTableCompanion.insert(
          apiId: 3, name: 'Salary', emoji: '💰', isIncome: true);
      final mockInsert = MockInsertStatement<$GroupTableTable, GroupDbModel>();
      when(db.into(groupTable)).thenReturn(mockInsert);
      when(mockInsert.insert(companion)).thenAnswer((_) async => 42);
      final id = await repo.createGroup(companion);
      expect(id, 42);
    });

    test('updateGroup updates group and returns true', () async {
      final companion = GroupTableCompanion.insert(
          apiId: 4, name: 'Other', emoji: '❓', isIncome: false);
      final mockUpdate = MockUpdateStatement<$GroupTableTable, GroupDbModel>();
      when(db.update(groupTable)).thenReturn(mockUpdate);
      when(mockUpdate.replace(companion)).thenAnswer((_) async => true);
      final result = await repo.updateGroup(companion);
      expect(result, true);
    });

    test('deleteGroup deletes group and returns count', () async {
      final mockDelete = MockDeleteStatement<$GroupTableTable, GroupDbModel>();
      when(db.delete(groupTable)).thenReturn(mockDelete);
      when(mockDelete.where(any)).thenReturn(mockDelete);
      when(mockDelete.go()).thenAnswer((_) async => 1);
      final result = await repo.deleteGroup(5);
      expect(result, 1);
    });

    test('getGroupsByType returns stream from db', () {
      final testGroup = const GroupDbModel(
          id: 6, apiId: 6, name: 'Income', emoji: '💵', isIncome: true);
      final stream = Stream.value([testGroup]);
      final mockSelect = MockGroupSimpleSelectStatement();
      when(db.select(groupTable)).thenReturn(mockSelect);
      when(mockSelect.where(any)).thenReturn(mockSelect);
      when(mockSelect.watch()).thenAnswer((_) => stream);
      expect(repo.getGroupsByType(true), emits(isA<List<GroupDbModel>>()));
    });

    test('searchGroups returns stream from db', () {
      final testGroup = const GroupDbModel(
          id: 7, apiId: 7, name: 'Search', emoji: '🔍', isIncome: false);
      final stream = Stream.value([testGroup]);
      final mockSelect = MockGroupSimpleSelectStatement();
      when(db.select(groupTable)).thenReturn(mockSelect);
      when(mockSelect.where(any)).thenReturn(mockSelect);
      when(mockSelect.watch()).thenAnswer((_) => stream);
      expect(repo.searchGroups('Search'), emits(isA<List<GroupDbModel>>()));
    });
  });
}

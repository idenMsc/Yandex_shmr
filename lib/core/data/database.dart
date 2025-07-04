import 'package:drift/drift.dart';

part './tables/wallet_table.dart';
part './tables/operation_table.dart';
part './tables/group_table.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [WalletTable, OperationTable, GroupTable],
)
class FinanceDatabase extends _$FinanceDatabase {
  FinanceDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
    );
  }

  /// Получить все кошельки
  Stream<List<WalletDbModel>> getAllWallets() => select(walletTable).watch();

  /// Получить все операции
  Stream<List<OperationDbModel>> getAllOperations() =>
      select(operationTable).watch();

  /// Получить все группы
  Stream<List<GroupDbModel>> getAllGroups() => select(groupTable).watch();

  /// Получить операции по кошельку
  Stream<List<OperationDbModel>> getOperationsByWallet(int walletId) =>
      (select(operationTable)..where((o) => o.walletId.equals(walletId)))
          .watch();
}

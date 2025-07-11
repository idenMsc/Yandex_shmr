import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shmr_25/core/data/backup_repository.dart';
import 'package:shmr_25/features/transactions/domain/entities/transaction.dart';

void main() {
  group('BackupRepository', () {
    late BackupRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      repository = BackupRepository();
    });

    test('should add and retrieve sync operations', () async {
      // Create a test transaction
      final transaction = Transaction(
        id: 123,
        account: AccountBrief(
          id: 1,
          name: 'Test Account',
          balance: 1000.0,
          currency: 'USD',
        ),
        category: Category(
          id: 1,
          name: 'Food',
          emoji: '🍕',
          isIncome: false,
        ),
        amount: 50.0,
        transactionDate: DateTime.now(),
        comment: 'Test transaction',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Create sync operation
      final operation = SyncOperation(
        type: SyncActionType.create,
        transaction: transaction,
        createdAt: DateTime.now(),
      );

      // Add operation
      await repository.addOrReplace(operation);

      // Retrieve all operations
      final operations = await repository.getAll();

      // Verify
      expect(operations.length, 1);
      expect(operations.first.type, SyncActionType.create);
      expect(operations.first.transaction.id, 123);
      expect(operations.first.transaction.amount, 50.0);
    });

    test('should replace operations with same unique key', () async {
      final transaction1 = Transaction(
        id: 123,
        account: AccountBrief(
            id: 1, name: 'Account', balance: 1000.0, currency: 'USD'),
        category: Category(id: 1, name: 'Food', emoji: '🍕', isIncome: false),
        amount: 50.0,
        transactionDate: DateTime.now(),
        comment: 'First',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final transaction2 = Transaction(
        id: 123,
        account: AccountBrief(
            id: 1, name: 'Account', balance: 1000.0, currency: 'USD'),
        category: Category(id: 1, name: 'Food', emoji: '🍕', isIncome: false),
        amount: 75.0, // Different amount
        transactionDate: DateTime.now(),
        comment: 'Second',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final operation1 = SyncOperation(
        type: SyncActionType.create,
        transaction: transaction1,
        createdAt: DateTime.now(),
      );

      final operation2 = SyncOperation(
        type: SyncActionType.create,
        transaction: transaction2,
        createdAt: DateTime.now(),
      );

      // Add first operation
      await repository.addOrReplace(operation1);

      // Add second operation (should replace first)
      await repository.addOrReplace(operation2);

      // Retrieve all operations
      final operations = await repository.getAll();

      // Verify only one operation exists with updated amount
      expect(operations.length, 1);
      expect(operations.first.transaction.amount, 75.0);
      expect(operations.first.transaction.comment, 'Second');
    });

    test('should remove operations by unique key', () async {
      final transaction = Transaction(
        id: 123,
        account: AccountBrief(
            id: 1, name: 'Account', balance: 1000.0, currency: 'USD'),
        category: Category(id: 1, name: 'Food', emoji: '🍕', isIncome: false),
        amount: 50.0,
        transactionDate: DateTime.now(),
        comment: 'Test',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final operation = SyncOperation(
        type: SyncActionType.create,
        transaction: transaction,
        createdAt: DateTime.now(),
      );

      // Add operation
      await repository.addOrReplace(operation);

      // Verify it exists
      var operations = await repository.getAll();
      expect(operations.length, 1);

      // Remove by unique key
      await repository.removeByUniqueKey(operation.uniqueKey);

      // Verify it's removed
      operations = await repository.getAll();
      expect(operations.length, 0);
    });
  });
}

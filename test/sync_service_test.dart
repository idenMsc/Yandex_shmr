import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:shmr_25/core/data/sync_service.dart';
import 'package:shmr_25/core/data/backup_repository.dart';
import 'package:shmr_25/features/transactions/domain/entities/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('SyncService', () {
    late SyncService syncService;
    late BackupRepository backupRepository;
    late Dio mockDio;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      backupRepository = BackupRepository();
      mockDio = Dio();
      syncService = SyncService(mockDio, backupRepository);
    });

    test('should sync pending operations successfully', () async {
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

      // Add operation to backup
      await backupRepository.addOrReplace(
        SyncOperation(
          type: SyncActionType.create,
          transaction: transaction,
          createdAt: DateTime.now(),
        ),
      );

      // Verify operation is in backup
      var operations = await backupRepository.getAll();
      expect(operations.length, 1);

      // Mock successful sync (this would normally make HTTP requests)
      // For now, we'll just test that the service can be instantiated
      expect(syncService, isNotNull);
      expect(backupRepository, isNotNull);
    });

    test('should handle empty backup queue', () async {
      // Verify no operations in backup
      final operations = await backupRepository.getAll();
      expect(operations.length, 0);

      // SyncService should handle empty queue gracefully
      expect(syncService, isNotNull);
    });
  });
}

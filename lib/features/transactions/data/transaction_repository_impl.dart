import 'package:dartz/dartz.dart';
import 'package:shmr_25/core/error/failures.dart';
import '../domain/entities/transaction.dart';
import '../domain/repositories/transaction_repository.dart';
import 'transaction_remote_data_source.dart';
import 'package:shmr_25/core/data/sync_service.dart';
import 'package:shmr_25/core/data/backup_repository.dart';
import 'package:shmr_25/core/connection_watcher.dart';
import '../../../core/network/connection_status_bloc.dart' as network;
import '../../../injection_container.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;
  final SyncService syncService;
  final BackupRepository backupRepository;
  final ConnectionWatcher connectionWatcher;

  TransactionRepositoryImpl({
    required this.remoteDataSource,
    required this.syncService,
    required this.backupRepository,
    required this.connectionWatcher,
  });

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByPeriod({
    required int accountId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Сначала пытаемся синхронизировать pending операции
      if (connectionWatcher.status == ConnectionStatus.online) {
        print(
            '[TransactionRepository] Syncing pending operations before fetching');
        await syncService.syncPendingOperations();
      }

      if (connectionWatcher.status == ConnectionStatus.online) {
        print('[TransactionRepository] Online: loading from server');
        final transactions = await remoteDataSource.getTransactionsByPeriod(
          accountId: accountId,
          startDate: startDate,
          endDate: endDate,
        );
        sl<network.ConnectionStatusBloc>().add(network.SetOfflineMode(false));
        return Right(transactions);
      } else {
        print('[TransactionRepository] Offline: loading from backup');
        final allOps = await backupRepository.getAll();
        final filtered = allOps
            .where((op) =>
                op.transaction.account.id == accountId &&
                op.transaction.transactionDate
                    .isAfter(startDate.subtract(const Duration(seconds: 1))) &&
                op.transaction.transactionDate
                    .isBefore(endDate.add(const Duration(seconds: 1))))
            .map((op) => op.transaction)
            .toList();
        sl<network.ConnectionStatusBloc>().add(network.SetOfflineMode(true));
        return Right(filtered);
      }
    } catch (e) {
      print('[TransactionRepository] Error loading transactions: $e');
      sl<network.ConnectionStatusBloc>().add(network.SetOfflineMode(true));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addTransaction(Transaction transaction) async {
    print('[TransactionRepository] Adding transaction: ${transaction.id}');
    try {
      // Сначала сохраняем локально в backup
      await backupRepository.addOrReplace(
        SyncOperation(
          type: SyncActionType.create,
          transaction: transaction,
          createdAt: DateTime.now(),
        ),
      );
      print('[TransactionRepository] Transaction saved to backup');

      // Если есть интернет, пытаемся синхронизировать
      if (connectionWatcher.status == ConnectionStatus.online) {
        print('[TransactionRepository] Online: syncing to server');
        await remoteDataSource.addTransaction(transaction);

        // Удаляем из backup после успешной синхронизации
        await backupRepository.removeByUniqueKey(
            '${SyncActionType.create.name}_${transaction.id}');
        print(
            '[TransactionRepository] Transaction synced and removed from backup');

        sl<network.ConnectionStatusBloc>().add(network.SetOfflineMode(false));
      } else {
        print(
            '[TransactionRepository] Offline: transaction saved to backup only');
        sl<network.ConnectionStatusBloc>().add(network.SetOfflineMode(true));
      }

      return const Right(null);
    } catch (e) {
      print('[TransactionRepository] Error adding transaction: $e');
      sl<network.ConnectionStatusBloc>().add(network.SetOfflineMode(true));
      return Left(ServerFailure(e.toString()));
    }
  }
}

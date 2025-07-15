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
import 'package:shmr_25/core/data/database_service.dart';
import 'package:shmr_25/core/data/repositories/operation_repository.dart';
import 'package:drift/drift.dart';
import '../../../core/data/database.dart';

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
      if (connectionWatcher.status == ConnectionStatus.online) {
        await syncService.syncPendingOperations();
      }

      final dbService = await DatabaseService.getInstance();
      final opRepo = dbService.operationRepository;

      if (connectionWatcher.status == ConnectionStatus.online) {
        final transactions = await remoteDataSource.getTransactionsByPeriod(
          accountId: accountId,
          startDate: startDate,
          endDate: endDate,
        );
        // Обновляем локальную базу
        await opRepo.deleteAllOperations();
        await opRepo.insertOperations(transactions
            .map((t) => OperationTableCompanion(
                  apiId: Value(t.id),
                  walletId: Value(t.account.id),
                  groupId: Value(t.category.id),
                  amount: Value(t.amount.toString()),
                  operationDate: Value(t.transactionDate),
                  comment: Value(t.comment ?? ''),
                ))
            .toList());
        // Получаем pending транзакции из backup
        final pendingOps = await backupRepository.getAll();
        final pendingTransactions = pendingOps
            .where((op) => op.type == SyncActionType.create)
            .map((op) => op.transaction)
            .where((t) => !transactions.any((lt) => lt.id == t.id))
            .toList();
        final allTransactions = [...transactions, ...pendingTransactions];
        sl<network.ConnectionStatusBloc>().add(network.SetOfflineMode(false));
        return Right(allTransactions);
      } else {
        // Оффлайн: читаем из локальной базы
        final allOps = await opRepo.getAllOperations().first;
        final localTransactions = allOps
            .where((op) =>
                op.walletId == accountId &&
                op.operationDate
                    .isAfter(startDate.subtract(const Duration(seconds: 1))) &&
                op.operationDate
                    .isBefore(endDate.add(const Duration(seconds: 1))))
            .map((op) => Transaction(
                  id: op.apiId ?? op.id,
                  account: AccountBrief(
                    id: op.walletId,
                    name: '',
                    balance: 0.0,
                    currency: '',
                  ),
                  category: Category(
                    id: op.groupId,
                    name: '',
                    emoji: '',
                    isIncome: false,
                  ),
                  amount: double.tryParse(op.amount) ?? 0.0,
                  transactionDate: op.operationDate,
                  comment: op.comment,
                  createdAt: op.operationDate,
                  updatedAt: op.operationDate,
                ))
            .toList();
        // Получаем pending транзакции из backup
        final pendingOps = await backupRepository.getAll();
        final pendingTransactions = pendingOps
            .where((op) => op.type == SyncActionType.create)
            .map((op) => op.transaction)
            .where((t) => !localTransactions.any((lt) => lt.id == t.id))
            .toList();
        final allTransactions = [...localTransactions, ...pendingTransactions];
        sl<network.ConnectionStatusBloc>().add(network.SetOfflineMode(true));
        return Right(allTransactions);
      }
    } catch (e) {
      sl<network.ConnectionStatusBloc>().add(network.SetOfflineMode(true));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addTransaction(Transaction transaction) async {
    print('[TransactionRepository] Adding transaction: ${transaction.id}');
    try {
      final dbService = await DatabaseService.getInstance();
      final opRepo = dbService.operationRepository;
      // Сохраняем в локальную базу
      await opRepo.createOperation(OperationTableCompanion(
        apiId: Value(transaction.id),
        walletId: Value(transaction.account.id),
        groupId: Value(transaction.category.id),
        amount: Value(transaction.amount.toString()),
        operationDate: Value(transaction.transactionDate),
        comment: Value(transaction.comment ?? ''),
      ));
      // Сохраняем в backup
      await backupRepository.addOrReplace(
        SyncOperation(
          type: SyncActionType.create,
          transaction: transaction,
          createdAt: DateTime.now(),
        ),
      );
      if (connectionWatcher.status == ConnectionStatus.online) {
        await remoteDataSource.addTransaction(transaction);
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

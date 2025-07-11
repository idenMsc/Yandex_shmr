import 'package:dartz/dartz.dart';
import 'package:shmr_25/core/error/failures.dart';
import '../domain/entities/transaction.dart';
import '../domain/repositories/transaction_repository.dart';
import 'transaction_remote_data_source.dart';
import 'package:shmr_25/core/data/sync_service.dart';
import 'package:shmr_25/core/connection_watcher.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;
  final SyncService syncService;
  final ConnectionWatcher connectionWatcher;

  TransactionRepositoryImpl({
    required this.remoteDataSource,
    required this.syncService,
    required this.connectionWatcher,
  });

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByPeriod({
    required int accountId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Перед каждым запросом — попытка синхронизации
      await syncService.sync();
      final transactions = await remoteDataSource.getTransactionsByPeriod(
        accountId: accountId,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(transactions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addTransaction(Transaction transaction) async {
    print('TransactionRepositoryImpl.addTransaction вызван');
    try {
      if (connectionWatcher.status == ConnectionStatus.online) {
        print('Сеть есть, отправляем на сервер');
        await remoteDataSource.addTransaction(transaction);
      } else {
        print('Нет сети, сохраняем в backup');
        await syncService.addToBackup(
          SyncOperation(type: SyncActionType.create, transaction: transaction),
        );
      }
      return const Right(null);
    } catch (e) {
      print('Ошибка в репозитории: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}

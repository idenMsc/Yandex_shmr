import 'package:dartz/dartz.dart';
import 'package:shmr_25/core/error/failures.dart';
import '../domain/entities/transaction.dart';
import '../domain/repositories/transaction_repository.dart';
import 'transaction_remote_data_source.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByPeriod({
    required int accountId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
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
    try {
      await remoteDataSource.addTransaction(transaction);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

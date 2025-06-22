import 'package:dartz/dartz.dart';
import 'package:shmr_25/core/error/failures.dart';
import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<Transaction>>> getTransactionsByPeriod({
    required int accountId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either<Failure, void>> addTransaction(Transaction transaction);
}

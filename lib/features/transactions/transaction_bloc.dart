import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/transaction_repository_impl.dart';
import 'data/account_remote_data_source.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepositoryImpl transactionRepository;
  final AccountRemoteDataSource accountRemoteDataSource;

  TransactionBloc({
    required this.transactionRepository,
    required this.accountRemoteDataSource,
  }) : super(TransactionInitial()) {
    on<LoadTransactionsEvent>(_onLoadTransactions);
    on<DeleteTransactionsEvent>(_onDeleteTransaction);
  }

  Future<void> _onDeleteTransaction(
    DeleteTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {}

  Future<void> _onLoadTransactions(
    LoadTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      final accounts = await accountRemoteDataSource.getAccounts();
      if (accounts.isEmpty) {
        emit(const TransactionError('Нет счетов'));
        return;
      }
      final accountId = accounts.first.id;
      final today = DateTime.now();
      final start = DateTime(today.year, today.month, today.day);
      final end = DateTime(today.year, today.month, today.day, 23, 59, 59);
      final result = await transactionRepository.getTransactionsByPeriod(
        accountId: accountId,
        startDate: start,
        endDate: end,
      );
      result.fold(
        (failure) => emit(TransactionError(failure.message)),
        (transactions) {
          final filtered = transactions
              .where((t) => t.category.isIncome == event.isIncome)
              .toList();
          final total = filtered.fold<double>(0, (sum, t) => sum + t.amount);
          emit(TransactionLoaded(transactions: filtered, total: total));
        },
      );
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}

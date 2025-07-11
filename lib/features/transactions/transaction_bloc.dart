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
    on<CreateTransactionEvent>(_onCreateTransaction);
    on<DeleteTransactionsEvent>(_onDeleteTransaction);
  }

  Future<void> _onCreateTransaction(
    CreateTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    print('TransactionBloc: создание транзакции');
    emit(TransactionCreating());
    try {
      final result =
          await transactionRepository.addTransaction(event.transaction);
      result.fold(
        (failure) => emit(TransactionError(failure.message)),
        (_) {
          print('TransactionBloc: транзакция создана успешно');
          emit(TransactionCreated());
          // Перезагружаем список транзакций
          add(LoadTransactionsEvent(
              isIncome: event.transaction.category.isIncome));
        },
      );
    } catch (e) {
      print('TransactionBloc: ошибка создания транзакции: $e');
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {}

  Future<void> _onLoadTransactions(
    LoadTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    print(
        'TransactionBloc._onLoadTransactions: загружаем ${event.isIncome ? "доходы" : "расходы"}');
    emit(TransactionLoading());
    try {
      final accounts = await accountRemoteDataSource.getAccounts();
      print('TransactionBloc: получено ${accounts.length} счетов с сервера');
      if (accounts.isEmpty) {
        print('TransactionBloc: нет счетов на сервере');
        emit(const TransactionError('Нет счетов'));
        return;
      }
      final accountId = accounts.first.id;
      print('TransactionBloc: используем accountId=$accountId');
      final today = DateTime.now();
      // Используем UTC для консистентности с сервером
      final start = DateTime.utc(today.year, today.month, today.day);
      final end = DateTime.utc(today.year, today.month, today.day, 23, 59, 59);
      print('TransactionBloc: период $start - $end');
      final result = await transactionRepository.getTransactionsByPeriod(
        accountId: accountId,
        startDate: start,
        endDate: end,
      );
      result.fold(
        (failure) {
          print(
              'TransactionBloc: ошибка загрузки транзакций: ${failure.message}');
          emit(TransactionError(failure.message));
        },
        (transactions) {
          print('TransactionBloc: получено ${transactions.length} транзакций');
          for (final t in transactions) {
            print(
                'Транзакция: ID=${t.id}, amount=${t.amount}, date=${t.transactionDate}, isIncome=${t.category.isIncome}');
          }
          final filtered = transactions
              .where((t) => t.category.isIncome == event.isIncome)
              .toList();
          print('TransactionBloc: отфильтровано ${filtered.length} транзакций');
          final total = filtered.fold<double>(0, (sum, t) => sum + t.amount);
          emit(TransactionLoaded(transactions: filtered, total: total));
        },
      );
    } catch (e) {
      print('TransactionBloc: исключение: $e');
      emit(TransactionError(e.toString()));
    }
  }
}

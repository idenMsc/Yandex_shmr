import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/transaction_repository_impl.dart';
import 'data/account_remote_data_source.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';
import '../../../core/error/global_ui_bloc.dart';
import '../../../injection_container.dart';

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
    sl<GlobalUiBloc>().add(ShowLoading());
    emit(TransactionCreating());
    try {
      final result =
          await transactionRepository.addTransaction(event.transaction);
      result.fold(
        (failure) {
          sl<GlobalUiBloc>().add(ShowError(failure.message));
          emit(TransactionError(failure.message));
        },
        (_) {
          emit(TransactionCreated());
          add(LoadTransactionsEvent(
              isIncome: event.transaction.category.isIncome));
        },
      );
    } catch (e) {
      sl<GlobalUiBloc>().add(ShowError(e.toString()));
      emit(TransactionError(e.toString()));
    } finally {
      sl<GlobalUiBloc>().add(HideLoading());
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
    sl<GlobalUiBloc>().add(ShowLoading());
    emit(TransactionLoading());
    try {
      final accounts = await accountRemoteDataSource.getAccounts();
      if (accounts.isEmpty) {
        sl<GlobalUiBloc>().add(ShowError('Нет счетов'));
        emit(const TransactionError('Нет счетов'));
        return;
      }
      final accountId = accounts.first.id;
      final today = DateTime.now();
      final start = DateTime.utc(today.year, today.month, today.day);
      final end = DateTime.utc(today.year, today.month, today.day, 23, 59, 59);
      final result = await transactionRepository.getTransactionsByPeriod(
        accountId: accountId,
        startDate: start,
        endDate: end,
      );
      result.fold(
        (failure) {
          sl<GlobalUiBloc>().add(ShowError(failure.message));
          emit(TransactionError(failure.message));
        },
        (transactions) {
          final filtered = transactions
              .where((t) => t.category.isIncome == event.isIncome)
              .toList();
          final total = filtered.fold<double>(0, (sum, t) => sum + t.amount);
          emit(TransactionLoaded(transactions: filtered, total: total));
        },
      );
    } catch (e) {
      sl<GlobalUiBloc>().add(ShowError(e.toString()));
      emit(TransactionError(e.toString()));
    } finally {
      sl<GlobalUiBloc>().add(HideLoading());
    }
  }
}

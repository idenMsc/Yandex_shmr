import 'package:flutter_bloc/flutter_bloc.dart';
import '../entities/transaction.dart';
import '../../data/transaction_repository_impl.dart';
import '../../data/account_remote_data_source.dart';
import '../../../../core/error/global_ui_bloc.dart';
import '../../../../injection_container.dart';

enum TransactionChartMode { byDay, byMonth }

class TransactionChartService extends Cubit<TransactionChartState> {
  final TransactionRepositoryImpl transactionRepository;
  final AccountRemoteDataSource accountRemoteDataSource;

  TransactionChartMode _mode = TransactionChartMode.byDay;
  List<Transaction> _transactions = [];

  TransactionChartService({
    required this.transactionRepository,
    required this.accountRemoteDataSource,
  }) : super(TransactionChartInitial());

  TransactionChartMode get mode => _mode;

  Future<void> loadTransactions() async {
    sl<GlobalUiBloc>().add(ShowLoading());
    emit(TransactionChartLoading());
    try {
      final accounts = await accountRemoteDataSource.getAccounts();
      if (accounts.isEmpty) {
        sl<GlobalUiBloc>().add(ShowError('Нет счетов'));
        emit(TransactionChartError('Нет счетов'));
        return;
      }
      final accountId = accounts.first.id;
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month - 1, now.day);
      final endDate = now;
      final result = await transactionRepository.getTransactionsByPeriod(
        accountId: accountId,
        startDate: startDate,
        endDate: endDate,
      );
      result.fold(
        (failure) {
          sl<GlobalUiBloc>().add(ShowError(failure.message));
          emit(TransactionChartError(failure.message));
        },
        (transactions) {
          _transactions = transactions;
          emit(TransactionChartLoaded(transactions: transactions));
        },
      );
    } catch (e) {
      sl<GlobalUiBloc>().add(ShowError(e.toString()));
      emit(TransactionChartError(e.toString()));
    } finally {
      sl<GlobalUiBloc>().add(HideLoading());
    }
  }

  void setMode(TransactionChartMode mode) {
    _mode = mode;
    if (_transactions.isNotEmpty) {
      emit(TransactionChartLoaded(transactions: _transactions));
    }
  }

  List<TransactionChartData> getChartData() {
    if (_transactions.isEmpty) return [];

    final now = DateTime.now();
    final Map<String, double> daySums = {};

    for (final transaction in _transactions) {
      final dateKey = _mode == TransactionChartMode.byDay
          ? '${transaction.transactionDate.year}-${transaction.transactionDate.month.toString().padLeft(2, '0')}-${transaction.transactionDate.day.toString().padLeft(2, '0')}'
          : '${transaction.transactionDate.year}-${transaction.transactionDate.month.toString().padLeft(2, '0')}';

      final signedAmount = transaction.category.isIncome
          ? transaction.amount
          : -transaction.amount;
      daySums[dateKey] = (daySums[dateKey] ?? 0) + signedAmount;
    }

    final List<TransactionChartData> chartData = [];

    if (_mode == TransactionChartMode.byDay) {
      // Группируем по дням за текущий месяц
      final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      for (int day = 1; day <= daysInMonth; day++) {
        final dateKey =
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
        final value = daySums[dateKey] ?? 0;
        chartData.add(TransactionChartData(
          x: day,
          value: value,
          label:
              '${day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}',
        ));
      }
    } else {
      // Группируем по месяцам за текущий год
      for (int month = 1; month <= now.month; month++) {
        final dateKey = '${now.year}-${month.toString().padLeft(2, '0')}';
        final value = daySums[dateKey] ?? 0;
        chartData.add(TransactionChartData(
          x: month,
          value: value,
          label: '${month.toString().padLeft(2, '0')}.${now.year}',
        ));
      }
    }

    return chartData;
  }
}

class TransactionChartData {
  final int x;
  final double value;
  final String label;

  TransactionChartData({
    required this.x,
    required this.value,
    required this.label,
  });
}

abstract class TransactionChartState {}

class TransactionChartInitial extends TransactionChartState {}

class TransactionChartLoading extends TransactionChartState {}

class TransactionChartLoaded extends TransactionChartState {
  final List<Transaction> transactions;

  TransactionChartLoaded({required this.transactions});
}

class TransactionChartError extends TransactionChartState {
  final String message;

  TransactionChartError(this.message);
}

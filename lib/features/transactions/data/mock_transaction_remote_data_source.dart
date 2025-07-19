import '../domain/entities/transaction.dart';
import 'transaction_remote_data_source.dart';
import '../../../core/network_service.dart';
import '../../../core/network_client.dart';

// Мок-данные (можно заменить на свои)
final _mockTransactions = <Transaction>[
  Transaction(
    id: 1,
    account: AccountBrief(
      id: 1,
      name: 'Основной счёт',
      balance: 1000.0,
      currency: 'RUB',
    ),
    category: Category(
      id: 1,
      name: 'Зарплата',
      emoji: '💰',
      isIncome: true,
    ),
    amount: 5000.0,
    transactionDate: DateTime.now(),
    comment: 'Мок доход',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Transaction(
    id: 2,
    account: AccountBrief(
      id: 1,
      name: 'Основной счёт',
      balance: 1000.0,
      currency: 'RUB',
    ),
    category: Category(
      id: 4,
      name: 'Продукты',
      emoji: '🍎',
      isIncome: false,
    ),
    amount: 1200.0,
    transactionDate: DateTime.now(),
    comment: 'Мок расход',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];

class MockTransactionRemoteDataSource extends TransactionRemoteDataSource {
  MockTransactionRemoteDataSource()
      : super(networkService: NetworkService(NetworkClient()));

  @override
  Future<List<Transaction>> getTransactionsByPeriod({
    required int accountId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Фильтрация по accountId и дате
    return _mockTransactions
        .where((t) =>
            t.account.id == accountId &&
            t.transactionDate
                .isAfter(startDate.subtract(const Duration(seconds: 1))) &&
            t.transactionDate.isBefore(endDate.add(const Duration(seconds: 1))))
        .toList();
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    // Можно добавить transaction в _mockTransactions, если нужно
    return;
  }
}

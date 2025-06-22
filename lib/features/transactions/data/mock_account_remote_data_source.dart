import '../domain/entities/account.dart';
import 'account_remote_data_source.dart';

// Мок-данные (можно заменить на свои)
final _mockAccounts = <Account>[
  Account(
    id: 1,
    userId: 1,
    name: 'Основной счёт',
    balance: 1000.0,
    currency: 'RUB',
    createdAt: DateTime.parse('2025-06-08T14:02:51.133Z'),
    updatedAt: DateTime.parse('2025-06-08T14:02:51.133Z'),
  ),
  Account(
    id: 2,
    userId: 1,
    name: 'Долларовый счёт',
    balance: 1500.0,
    currency: 'USD',
    createdAt: DateTime.parse('2025-05-01T10:30:00.000Z'),
    updatedAt: DateTime.parse('2025-06-01T15:45:00.000Z'),
  ),
];

class MockAccountRemoteDataSource extends AccountRemoteDataSource {
  MockAccountRemoteDataSource() : super(baseUrl: '', token: '');

  @override
  Future<List<Account>> getAccounts() async {
    return _mockAccounts;
  }
}

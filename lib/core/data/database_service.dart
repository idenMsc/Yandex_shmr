import 'package:drift/drift.dart';
import 'database.dart';
import 'database_helper.dart';
import 'repositories/wallet_repository.dart';
import 'repositories/operation_repository.dart';
import 'repositories/group_repository.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static FinanceDatabase? _database;

  late final WalletRepository walletRepository;
  late final OperationRepository operationRepository;
  late final GroupRepository groupRepository;

  DatabaseService._();

  static Future<DatabaseService> getInstance() async {
    if (_instance == null) {
      _instance = DatabaseService._();
      await _instance!._initialize();
    }
    return _instance!;
  }

  Future<void> _initialize() async {
    _database = await DatabaseHelper.database;

    walletRepository = WalletRepository(_database!);
    operationRepository = OperationRepository(_database!);
    groupRepository = GroupRepository(_database!);

    // Инициализация тестовыми данными
    await _initializeTestData();
  }

  Future<void> _initializeTestData() async {
    // Проверяем, есть ли уже данные
    final wallets = await walletRepository.getAllWallets().first;
    if (wallets.isNotEmpty) return;

    // Создаем тестовые группы
    final expenseGroupId = await groupRepository.createGroup(
      GroupTableCompanion.insert(
        apiId: 1,
        name: 'Продукты',
        emoji: '🛒',
        isIncome: false,
      ),
    );

    final incomeGroupId = await groupRepository.createGroup(
      GroupTableCompanion.insert(
        apiId: 2,
        name: 'Зарплата',
        emoji: '💰',
        isIncome: true,
      ),
    );

    // Создаем тестовый кошелек
    final walletId = await walletRepository.createWallet(
      WalletTableCompanion.insert(
        apiId: 1,
        userId: 1,
        name: 'Основной счет',
        balance: '123456.78',
        currency: '₽',
      ),
    );

    // Создаем тестовые операции
    await operationRepository.createOperation(
      OperationTableCompanion.insert(
        apiId: const Value(1),
        walletId: walletId,
        groupId: expenseGroupId,
        amount: '5000.00',
        operationDate: DateTime.now().subtract(const Duration(days: 1)),
        comment: const Value('Продукты на неделю'),
      ),
    );

    await operationRepository.createOperation(
      OperationTableCompanion.insert(
        apiId: const Value(2),
        walletId: walletId,
        groupId: incomeGroupId,
        amount: '150000.00',
        operationDate: DateTime.now().subtract(const Duration(days: 7)),
        comment: const Value('Зарплата за месяц'),
      ),
    );
  }

  Future<void> close() async {
    await DatabaseHelper.closeDatabase();
    _instance = null;
    _database = null;
  }
}

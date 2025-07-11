import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../transaction_bloc.dart';
import '../transaction_event.dart';
import '../transaction_state.dart';
import '../domain/entities/transaction.dart';
import '../../categories/domain/entities/category.dart' as category_entity;
import '../../categories/presentation/bloc/category_bloc.dart';
import '../../../core/data/database.dart';
import '../../bank_accounts/presentation/bloc/wallet_bloc.dart';
import '../data/account_remote_data_source.dart';
import '../domain/entities/account.dart';

class TransactionCreateModal extends StatefulWidget {
  final bool isIncome;

  const TransactionCreateModal({Key? key, required this.isIncome})
      : super(key: key);

  static Future<void> show(BuildContext context,
      {required bool isIncome}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionCreateModal(isIncome: isIncome),
    );
  }

  @override
  State<TransactionCreateModal> createState() => _TransactionCreateModalState();
}

class _TransactionCreateModalState extends State<TransactionCreateModal> {
  Account? _selectedAccount;
  category_entity.Category? _selectedCategory;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<Account> _accounts = [];
  bool _isLoadingAccounts = true;

  @override
  void initState() {
    super.initState();
    print('TransactionCreateModal.initState() вызван');
    _amountController.addListener(() {
      setState(() {});
    });
    // Загружаем категории если еще не загружены
    print('Отправляем LoadCategories в CategoryBloc');
    context.read<CategoryBloc>().add(LoadCategories());
    // Загружаем счета с сервера
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    print('Загружаем счета с сервера...');
    try {
      final accountDataSource = AccountRemoteDataSource(
        networkService: context
            .read<TransactionBloc>()
            .accountRemoteDataSource
            .networkService,
      );
      final accounts = await accountDataSource.getAccounts();
      print('Получено ${accounts.length} счетов с сервера');
      setState(() {
        _accounts = accounts;
        _isLoadingAccounts = false;
        if (accounts.isNotEmpty) {
          _selectedAccount = accounts.first;
          print(
              'Автоматически выбран первый счет: ${_selectedAccount!.name} (ID: ${_selectedAccount!.id})');
        }
      });
    } catch (e) {
      print('Ошибка загрузки счетов: $e');
      setState(() {
        _isLoadingAccounts = false;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  bool get isValid =>
      _selectedAccount != null &&
      _selectedCategory != null &&
      _amountController.text.trim().isNotEmpty &&
      double.tryParse(_amountController.text) != null &&
      double.parse(_amountController.text) > 0;

  Future<void> _selectAccount() async {
    print('_selectAccount вызван, доступно счетов: ${_accounts.length}');
    final selected = await showModalBottomSheet<Account>(
      context: context,
      builder: (context) => _accounts.isEmpty
          ? const Center(
              child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Нет доступных счетов')))
          : ListView(
              children: _accounts
                  .map((a) => ListTile(
                        title: Text(a.name),
                        subtitle: Text('${a.balance} ${a.currency}'),
                        onTap: () => Navigator.pop(context, a),
                      ))
                  .toList(),
            ),
    );
    if (selected != null) {
      print('Выбран счет: ${selected.name} (ID: ${selected.id})');
      setState(() => _selectedAccount = selected);
    }
  }

  Future<void> _selectCategory(
      List<category_entity.Category> categories) async {
    print('_selectCategory вызван, доступно категорий: ${categories.length}');
    final filtered =
        categories.where((c) => c.isIncome == widget.isIncome).toList();
    print(
        'Отфильтровано категорий для ${widget.isIncome ? "доходов" : "расходов"}: ${filtered.length}');
    final selected = await showModalBottomSheet<category_entity.Category>(
      context: context,
      builder: (context) => filtered.isEmpty
          ? const Center(
              child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Нет доступных категорий')))
          : ListView(
              children: filtered
                  .map((c) => ListTile(
                        leading: Text(c.emoji ?? '📂'),
                        title: Text(c.name),
                        onTap: () => Navigator.pop(context, c),
                      ))
                  .toList(),
            ),
    );
    if (selected != null) {
      print('Выбрана категория: ${selected.name} (ID: ${selected.id})');
      setState(() => _selectedCategory = selected);
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _save() {
    print('TransactionCreateModal._save() вызван');
    if (!isValid) {
      print('Форма невалидна');
      return;
    }

    // Создаем дату в UTC для консистентности с сервером
    final dt = DateTime.utc(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _selectedTime.hour, _selectedTime.minute);

    print(
        'Выбранный счет: ${_selectedAccount?.name} (ID: ${_selectedAccount?.id})');
    print(
        'Выбранная категория: ${_selectedCategory?.name} (ID: ${_selectedCategory?.id})');
    print('Сумма: ${_amountController.text}');
    print('Дата (UTC): $dt');
    print('Дата в ISO: ${dt.toIso8601String()}');

    // Создаем Transaction для API
    final transaction = Transaction(
      id: 0, // Временный ID, сервер присвоит реальный
      account: AccountBrief(
        id: _selectedAccount!.id,
        name: _selectedAccount!.name,
        balance: _selectedAccount!.balance,
        currency: _selectedAccount!.currency,
      ),
      category: Category(
        id: _selectedCategory!.id,
        name: _selectedCategory!.name,
        emoji: _selectedCategory!.emoji ?? '📂',
        isIncome: _selectedCategory!.isIncome,
      ),
      amount: double.parse(_amountController.text),
      transactionDate: dt,
      comment: _commentController.text.isEmpty ? null : _commentController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    print(
        'Создаем транзакцию: ${transaction.amount} ${transaction.category.name}');
    print('Отправляем CreateTransactionEvent в TransactionBloc');
    context
        .read<TransactionBloc>()
        .add(CreateTransactionEvent(transaction: transaction));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, categoryState) {
        final categories = categoryState is CategoryLoaded
            ? categoryState.categories
            : <category_entity.Category>[];

        print(
            'TransactionCreateModal.build: accounts=${_accounts.length}, categories=${categories.length}');
        print('CategoryState: ${categoryState.runtimeType}');

        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.isIncome ? 'Добавить доход' : 'Добавить расход',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(_selectedAccount?.name ?? 'Загрузка счетов...'),
                    subtitle: _selectedAccount != null
                        ? Text(
                            '${_selectedAccount!.balance} ${_selectedAccount!.currency}')
                        : null,
                    onTap: _isLoadingAccounts ? null : _selectAccount,
                    leading: const Icon(Icons.account_balance_wallet),
                  ),
                  ListTile(
                    title:
                        Text(_selectedCategory?.name ?? 'Выберите категорию'),
                    leading: Text(_selectedCategory?.emoji ?? '📂',
                        style: const TextStyle(fontSize: 24)),
                    onTap: () => _selectCategory(categories),
                  ),
                  TextField(
                    controller: _amountController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Сумма'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(
                              'Дата: ${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}'),
                          leading: const Icon(Icons.date_range),
                          onTap: _selectDate,
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title:
                              Text('Время: ${_selectedTime.format(context)}'),
                          leading: const Icon(Icons.access_time),
                          onTap: _selectTime,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(labelText: 'Комментарий'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isValid ? _save : null,
                    child: const Text('Сохранить'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

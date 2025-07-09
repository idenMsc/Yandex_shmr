import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/utils/constants.dart';
import '../../../l10n/app_localizations.dart';
import '../../bank_accounts/presentation/bloc/operation_bloc.dart';
import '../../bank_accounts/presentation/bloc/wallet_bloc.dart';
import '../../../core/data/database.dart';
import 'package:shmr_25/features/categories/presentation/bloc/category_bloc.dart';
import 'package:shmr_25/features/categories/domain/entities/category.dart';

class OperationEditModal extends StatefulWidget {
  final bool isIncome;
  final OperationDbModel? initialOperation;

  const OperationEditModal(
      {Key? key, this.isIncome = false, this.initialOperation})
      : super(key: key);

  static Future<void> show(BuildContext context,
      {bool isIncome = false, OperationDbModel? initialOperation}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OperationEditModal(
          isIncome: isIncome, initialOperation: initialOperation),
    );
  }

  @override
  State<OperationEditModal> createState() => _OperationEditModalState();
}

class _OperationEditModalState extends State<OperationEditModal> {
  WalletDbModel? _selectedWallet;
  // Используем тот же список категорий, что и на categories_page
  final List<List<String>> _categories = [
    ['Аренда квартиры', '🏡'],
    ['Одежда', '👗'],
    ['На собачку', '🐶'],
    ['Ремонт квартиры'],
    ['Продукты', '🍭'],
    ['Спортзал', '🏋️'],
    ['Медицина', '💊'],
  ];
  Category? _selectedCategory;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    if (widget.initialOperation != null) {
      // TODO: инициализация из существующей операции
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  bool get isValid =>
      _selectedWallet != null &&
      _selectedCategory != null &&
      _amountController.text.trim().isNotEmpty &&
      double.tryParse(_amountController.text) != null &&
      double.parse(_amountController.text) > 0;

  void _selectWallet(List<WalletDbModel> wallets) async {
    final selected = await showModalBottomSheet<WalletDbModel>(
      context: context,
      builder: (context) => wallets.isEmpty
          ? const Center(
              child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('Нет доступных счетов'),
            ))
          : ListView(
              children: wallets
                  .map((w) => ListTile(
                        title:
                            Text(w.name), // <-- теперь отображается имя счета
                        subtitle: Text('${w.balance} ${w.currency}'),
                        onTap: () => Navigator.pop(context, w),
                      ))
                  .toList(),
            ),
    );
    if (selected != null) setState(() => _selectedWallet = selected);
  }

  void _selectCategory(List<Category> categories) async {
    // Используем _categories вместо categories из Bloc
    final selected = await showModalBottomSheet<Map<String, String>>(
      context: context,
      builder: (context) => _categories.isEmpty
          ? const Center(
              child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('Нет доступных категорий'),
            ))
          : ListView(
              children: _categories
                  .map((c) => ListTile(
                        leading: Text(c.length > 1 ? c[1] : '📂'),
                        title: Text(c[0]),
                        onTap: () => Navigator.pop(context, {
                          'name': c[0],
                          'emoji': c.length > 1 ? c[1] : '📂'
                        }),
                      ))
                  .toList(),
            ),
    );
    if (selected != null) {
      setState(() => _selectedCategory = Category(
            id: 0, // id не используется, можно доработать если потребуется
            name: selected['name']!,
            emoji: selected['emoji']!,
            isIncome: widget.isIncome,
          ));
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
    if (!isValid) return;
    final dt = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _selectedTime.hour, _selectedTime.minute);
    // Для groupId используем 1 (доход) или 4 (расход) — как в тестовых данных
    final groupId = widget.isIncome ? 1 : 4;
    final operation = OperationTableCompanion(
      walletId: drift.Value(_selectedWallet!.id),
      groupId: drift.Value(groupId),
      amount: drift.Value(_amountController.text),
      operationDate: drift.Value(dt),
      comment: drift.Value(_commentController.text),
    );
    context.read<OperationBloc>().add(CreateOperation(operation));
    // Немедленно обновляем историю
    context.read<OperationBloc>().add(LoadOperations());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, walletState) {
        return BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, categoryState) {
            final wallets = walletState is WalletsLoaded
                ? walletState.wallets
                : <WalletDbModel>[];
            final categories = categoryState is CategoryLoaded
                ? categoryState.categories
                : <Category>[];
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
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
                      Text(
                          widget.isIncome
                              ? 'Добавить доход'
                              : 'Добавить расход',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 16),
                      ListTile(
                        title: Text(_selectedWallet?.name ?? 'Выберите счет'),
                        subtitle: _selectedWallet != null
                            ? Text(
                                '${_selectedWallet!.balance} ${_selectedWallet!.currency}')
                            : null,
                        onTap: () => _selectWallet(wallets),
                        leading: const Icon(Icons.account_balance_wallet),
                      ),
                      ListTile(
                        title: Text(
                            _selectedCategory?.name ?? 'Выберите категорию'),
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
                              title: Text(
                                  'Время: ${_selectedTime.format(context)}'),
                              leading: const Icon(Icons.access_time),
                              onTap: _selectTime,
                            ),
                          ),
                        ],
                      ),
                      TextField(
                        controller: _commentController,
                        decoration:
                            const InputDecoration(labelText: 'Комментарий'),
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
      },
    );
  }
}

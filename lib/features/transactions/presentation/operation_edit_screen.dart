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

/// Экран создания/редактирования операции
class OperationEditScreen extends StatefulWidget {
  const OperationEditScreen({
    super.key,
    this.initialOperation,
    this.isIncome = false,
  });

  final OperationDbModel? initialOperation;
  final bool isIncome;

  @override
  State<OperationEditScreen> createState() => _OperationEditScreenState();
}

class _OperationEditScreenState extends State<OperationEditScreen> {
  WalletDbModel? _selectedWallet;
  String? _selectedCategory;
  late double _amount;
  late DateTime _operationDate;
  String? _comment;

  bool get _hasChanges {
    // Проверяем что все обязательные поля заполнены
    if (_selectedWallet == null || _selectedCategory == null || _amount <= 0) {
      return false;
    }

    // Если создаем операцию - сохранение доступно при валидных данных
    if (widget.initialOperation == null) return true;

    // Для редактирования проверяем изменения
    final walletChanged =
        _selectedWallet?.id != widget.initialOperation?.walletId;
    final categoryChanged = _selectedCategory !=
        _getCategoryFromGroupId(widget.initialOperation!.groupId);
    final amountChanged =
        _amount != double.parse(widget.initialOperation!.amount);
    final dateChanged =
        _operationDate != widget.initialOperation!.operationDate;
    final commentChanged = _comment != widget.initialOperation?.comment;
    return walletChanged ||
        categoryChanged ||
        amountChanged ||
        dateChanged ||
        commentChanged;
  }

  String _getCategoryFromGroupId(int groupId) {
    if (widget.isIncome) {
      switch (groupId) {
        case 1:
          return 'Зарплата';
        case 2:
          return 'Подарки';
        case 3:
          return 'Инвестиции';
        default:
          return 'Другое';
      }
    } else {
      switch (groupId) {
        case 4:
          return 'Продукты';
        case 5:
          return 'Транспорт';
        case 6:
          return 'Развлечения';
        case 7:
          return 'Одежда';
        case 8:
          return 'Здоровье';
        default:
          return 'Другое';
      }
    }
  }

  int _getGroupIdFromCategory(String category) {
    if (widget.isIncome) {
      switch (category) {
        case 'Зарплата':
          return 1;
        case 'Подарки':
          return 2;
        case 'Инвестиции':
          return 3;
        default:
          return 4;
      }
    } else {
      switch (category) {
        case 'Продукты':
          return 4;
        case 'Транспорт':
          return 5;
        case 'Развлечения':
          return 6;
        case 'Одежда':
          return 7;
        case 'Здоровье':
          return 8;
        default:
          return 9;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialOperation != null) {
      _initFromOperation(widget.initialOperation!);
    } else {
      _operationDate = DateTime.now();
      _amount = 0.0; // Начинаем с 0, кнопка сохранения будет неактивна
    }
  }

  void _initFromOperation(OperationDbModel operation) {
    // Находим кошелек по ID
    final walletBloc = context.read<WalletBloc>();
    final wallets = walletBloc.state;
    if (wallets is WalletsLoaded) {
      _selectedWallet = wallets.wallets.firstWhere(
        (w) => w.id == operation.walletId,
        orElse: () => wallets.wallets.first,
      );
    }
    _selectedCategory = _getCategoryFromGroupId(operation.groupId);
    _amount = double.parse(operation.amount);
    _operationDate = operation.operationDate;
    _comment = operation.comment;
  }

  Future<void> _selectWallet() async {
    final walletBloc = context.read<WalletBloc>();
    final wallets = walletBloc.state;
    if (wallets is! WalletsLoaded || wallets.wallets.isEmpty) return;

    final selectedWallet = await showModalBottomSheet<WalletDbModel>(
      context: context,
      builder: (context) => _WalletSelectorSheet(
        wallets: wallets.wallets,
        currentWalletId: _selectedWallet?.id,
      ),
    );
    if (selectedWallet != null) {
      setState(() => _selectedWallet = selectedWallet);
    }
  }

  Future<void> _selectCategory() async {
    final categories = widget.isIncome
        ? ['Зарплата', 'Подарки', 'Инвестиции', 'Другое']
        : [
            'Продукты',
            'Транспорт',
            'Развлечения',
            'Одежда',
            'Здоровье',
            'Другое'
          ];

    final selectedCategory = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => _CategorySelectorSheet(
        categories: categories,
        currentCategory: _selectedCategory,
      ),
    );
    if (selectedCategory != null) {
      setState(() => _selectedCategory = selectedCategory);
    }
  }

  Future<void> _selectAmount() async {
    if (_selectedWallet == null) return;

    final result = await showDialog<double>(
      context: context,
      builder: (context) => _AmountInputDialog(
        initialAmount: _amount,
        currency: _selectedWallet!.currency,
      ),
    );
    if (result != null) {
      setState(() => _amount = result);
    }
  }

  Future<void> _selectDate() async {
    final dtNow = DateTime.now();
    final effectiveFirstDate = dtNow.copyWith(year: dtNow.year - 1);
    final effectiveEndDate = dtNow; // Ограничиваем до текущего дня

    final date = await showDatePicker(
      context: context,
      firstDate: effectiveFirstDate,
      lastDate: effectiveEndDate,
      initialDate: _operationDate.isAfter(effectiveEndDate)
          ? effectiveEndDate
          : _operationDate,
    );
    if (date != null) {
      setState(() => _operationDate = _operationDate.copyWith(
            year: date.year,
            month: date.month,
            day: date.day,
          ));
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_operationDate),
    );
    if (time != null) {
      setState(() => _operationDate = _operationDate.copyWith(
            hour: time.hour,
            minute: time.minute,
          ));
    }
  }

  Future<void> _selectComment() async {
    final controller = TextEditingController(text: _comment ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Комментарий'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Комментарий',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text('OK'),
          ),
        ],
      ),
    );
    if (result != null) {
      setState(() => _comment = result.isEmpty ? null : result);
    }
  }

  Future<void> _deleteOperation() async {
    if (widget.initialOperation == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Удалить операцию?'),
        content: Text('Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Удалить'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final operationBloc = context.read<OperationBloc>();
      operationBloc.add(DeleteOperation(widget.initialOperation!.id));
      Navigator.pop(context);
    }
  }

  Future<void> _saveOperation() async {
    // Валидация полей
    final validationErrors = <String>[];

    if (_selectedWallet == null) {
      validationErrors.add('Выберите счет');
    }

    if (_selectedCategory == null) {
      validationErrors.add('Выберите статью');
    }

    if (_amount <= 0) {
      validationErrors.add('Введите сумму больше нуля');
    }

    if (validationErrors.isNotEmpty) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Заполните все поля'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: validationErrors
                .map((error) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text('• $error'),
                    ))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final operationBloc = context.read<OperationBloc>();

    if (widget.initialOperation != null) {
      // Обновление существующей операции
      final updatedOperation = OperationTableCompanion(
        id: drift.Value(widget.initialOperation!.id),
        apiId: drift.Value(widget.initialOperation!.apiId),
        walletId: drift.Value(_selectedWallet!.id),
        groupId: drift.Value(_getGroupIdFromCategory(_selectedCategory!)),
        amount: drift.Value(_amount.toString()),
        operationDate: drift.Value(_operationDate),
        comment: _comment != null
            ? drift.Value(_comment!)
            : const drift.Value.absent(),
      );
      operationBloc.add(CreateOperation(updatedOperation));
    } else {
      // Создание новой операции
      final newOperation = OperationTableCompanion.insert(
        walletId: _selectedWallet!.id,
        groupId: _getGroupIdFromCategory(_selectedCategory!),
        amount: _amount.toString(),
        operationDate: _operationDate,
        comment: _comment != null
            ? drift.Value(_comment!)
            : const drift.Value.absent(),
      );
      operationBloc.add(CreateOperation(newOperation));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
        title: Text(widget.initialOperation != null
            ? 'Редактировать'
            : 'Новая операция'),
        actions: [
          if (_hasChanges)
            IconButton(
              onPressed: _saveOperation,
              icon: const Icon(Icons.done),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...ListTile.divideTiles(
            context: context,
            tiles: [
              // Счет
              ListTile(
                onTap: _selectWallet,
                title: Row(
                  children: [
                    Text('Счет'),
                    if (_selectedWallet != null)
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(_selectedWallet!.name),
                        ),
                      ),
                  ],
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppColors.tertiary.withOpacity(0.3),
                ),
              ),
              // Статья
              ListTile(
                onTap: _selectCategory,
                title: Row(
                  children: [
                    Text('Статья'),
                    if (_selectedCategory != null)
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(_selectedCategory!),
                        ),
                      ),
                  ],
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppColors.tertiary.withOpacity(0.3),
                ),
              ),
              // Сумма
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: _selectedWallet == null
                    ? const SizedBox.shrink()
                    : ListTile(
                        onTap: _selectAmount,
                        title: Row(
                          children: [
                            Text('Сумма'),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  _amount > 0
                                      ? '${_amount.toStringAsFixed(2)} ${_selectedWallet!.currency}'
                                      : 'Введите сумму',
                                  style: _amount > 0
                                      ? AppTextStyles.bodyLarge
                                      : AppTextStyles.bodyLarge
                                          .copyWith(color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              // Дата
              ListTile(
                onTap: _selectDate,
                title: Row(
                  children: [
                    Text('Дата'),
                    const Spacer(),
                    Text(
                        '${_operationDate.day.toString().padLeft(2, '0')}.${_operationDate.month.toString().padLeft(2, '0')}.${_operationDate.year}'),
                  ],
                ),
              ),
              // Время
              ListTile(
                onTap: _selectTime,
                title: Row(
                  children: [
                    Text('Время'),
                    const Spacer(),
                    Text(
                        '${_operationDate.hour.toString().padLeft(2, '0')}:${_operationDate.minute.toString().padLeft(2, '0')}'),
                  ],
                ),
              ),
              // Комментарий
              ListTile(
                onTap: _selectComment,
                title: _comment?.trim().isEmpty ?? true
                    ? Text('Комментарий', style: TextStyle(color: Colors.grey))
                    : Text(_comment!),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 32),
          if (widget.initialOperation != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: _deleteOperation,
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                child:
                    Text(widget.isIncome ? 'Удалить доход' : 'Удалить расход'),
              ),
            ),
        ],
      ),
    );
  }
}

/// Виджет выбора кошелька
class _WalletSelectorSheet extends StatelessWidget {
  const _WalletSelectorSheet({
    required this.wallets,
    this.currentWalletId,
  });

  final List<WalletDbModel> wallets;
  final int? currentWalletId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Выберите счет',
            style: AppTextStyles.titleLarge,
          ),
          const SizedBox(height: 16),
          ...wallets.map((wallet) => ListTile(
                title: Text(wallet.name),
                subtitle: Text('Баланс: ${wallet.balance} ${wallet.currency}'),
                trailing: currentWalletId == wallet.id
                    ? Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.pop(context, wallet),
              )),
        ],
      ),
    );
  }
}

/// Виджет выбора категории
class _CategorySelectorSheet extends StatelessWidget {
  const _CategorySelectorSheet({
    required this.categories,
    this.currentCategory,
  });

  final List<String> categories;
  final String? currentCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Выберите статью',
            style: AppTextStyles.titleLarge,
          ),
          const SizedBox(height: 16),
          ...categories.map((category) => ListTile(
                title: Text(category),
                trailing: currentCategory == category
                    ? Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.pop(context, category),
              )),
        ],
      ),
    );
  }
}

/// Диалог ввода суммы
class _AmountInputDialog extends StatefulWidget {
  const _AmountInputDialog({
    required this.initialAmount,
    required this.currency,
  });

  final double initialAmount;
  final String currency;

  @override
  State<_AmountInputDialog> createState() => _AmountInputDialogState();
}

class _AmountInputDialogState extends State<_AmountInputDialog> {
  late double _amount;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _amount = widget.initialAmount;
    _controller = TextEditingController(
      text: _amount > 0 ? _amount.toStringAsFixed(2) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final decimalSeparator = AppLocalizations.of(context)!.decimalSeparator;
    // Заменяем разделитель на точку для парсинга
    final normalizedValue = value.replaceAll(decimalSeparator, '.');
    final newAmount = double.tryParse(normalizedValue) ?? 0.0;
    setState(() => _amount = newAmount);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Введите сумму'),
      content: TextFormField(
        controller: _controller,
        onChanged: _onChanged,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          suffixText: widget.currency,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
          _DecimalFormatter(AppLocalizations.of(context)!.decimalSeparator),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Отмена'),
        ),
        TextButton(
          onPressed: _amount > 0 && _amount != widget.initialAmount
              ? () => Navigator.pop(context, _amount)
              : null,
          child: Text('Сохранить'),
        ),
      ],
    );
  }
}

/// Форматтер для десятичных чисел с учетом локализации
class _DecimalFormatter extends TextInputFormatter {
  final String decimalSeparator;

  _DecimalFormatter(this.decimalSeparator);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Заменяем оба разделителя на используемый в локали
    String newText = newValue.text
        .replaceAll(',', decimalSeparator)
        .replaceAll('.', decimalSeparator);

    // Разрешить только один разделитель
    final separatorCount = decimalSeparator.allMatches(newText).length;
    if (separatorCount > 1) return oldValue;

    // Разделяем целую и дробную часть
    final parts = newText.split(decimalSeparator);

    if (parts.length > 2) {
      return oldValue;
    }

    // Обрезаем дробную часть до 2 знаков
    if (parts.length == 2 && parts[1].length > 2) {
      parts[1] = parts[1].substring(0, 2);
      newText = '${parts[0]}$decimalSeparator${parts[1]}';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

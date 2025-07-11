import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bank_accounts/presentation/bloc/operation_bloc.dart';
import '../../../core/data/database.dart';
import '../../bank_accounts/presentation/bloc/wallet_bloc.dart';
import '../../categories/presentation/bloc/category_bloc.dart';
import '../../categories/domain/entities/category.dart';
import 'package:drift/drift.dart' as drift;

class TransactionDetailsModal extends StatefulWidget {
  final OperationDbModel operation;
  final Category category;
  final WalletDbModel wallet;

  const TransactionDetailsModal({
    Key? key,
    required this.operation,
    required this.category,
    required this.wallet,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required OperationDbModel operation,
    required Category category,
    required WalletDbModel wallet,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionDetailsModal(
        operation: operation,
        category: category,
        wallet: wallet,
      ),
    );
  }

  @override
  State<TransactionDetailsModal> createState() =>
      _TransactionDetailsModalState();
}

class _TransactionDetailsModalState extends State<TransactionDetailsModal> {
  late WalletDbModel _selectedWallet;
  late Category _selectedCategory;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late TextEditingController _amountController;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _selectedWallet = widget.wallet;
    _selectedCategory = widget.category;
    _selectedDate = widget.operation.operationDate;
    _selectedTime = TimeOfDay.fromDateTime(widget.operation.operationDate);
    _amountController = TextEditingController(text: widget.operation.amount);
    _commentController =
        TextEditingController(text: widget.operation.comment ?? '');
  }

  @override
  void dispose() {
    _amountController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _selectWallet(List<WalletDbModel> wallets) async {
    final selected = await showModalBottomSheet<WalletDbModel>(
      context: context,
      builder: (context) => wallets.isEmpty
          ? const Center(
              child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Нет доступных счетов')))
          : ListView(
              children: wallets
                  .map((w) => ListTile(
                        title: Text(w.name),
                        subtitle: Text('${w.balance} ${w.currency}'),
                        onTap: () => Navigator.pop(context, w),
                      ))
                  .toList(),
            ),
    );
    if (selected != null) setState(() => _selectedWallet = selected);
  }

  Future<void> _selectCategory(List<Category> categories) async {
    final filtered = categories
        .where((c) => c.isIncome == widget.category.isIncome)
        .toList();
    final selected = await showModalBottomSheet<Category>(
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
    if (selected != null) setState(() => _selectedCategory = selected);
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

  bool get isValid =>
      _selectedWallet != null &&
      _selectedCategory != null &&
      _amountController.text.trim().isNotEmpty &&
      double.tryParse(_amountController.text) != null &&
      double.parse(_amountController.text) > 0;

  void _save() {
    if (!isValid) return;
    final dt = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _selectedTime.hour, _selectedTime.minute);
    final operation = OperationTableCompanion(
      id: drift.Value(widget.operation.id),
      walletId: drift.Value(_selectedWallet.id),
      groupId: drift.Value(_selectedCategory.id),
      amount: drift.Value(_amountController.text),
      operationDate: drift.Value(dt),
      comment: drift.Value(_commentController.text),
    );
    if (widget.operation.id == null) {
      context.read<OperationBloc>().add(CreateOperation(operation));
    } else {
      context.read<OperationBloc>().add(UpdateOperation(operation));
    }
    Navigator.pop(context);
  }

  void _delete() {
    context.read<OperationBloc>().add(DeleteOperation(widget.operation.id));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditMode = widget.operation.id != null;
    final wallets = context.read<WalletBloc>().state is WalletsLoaded
        ? (context.read<WalletBloc>().state as WalletsLoaded).wallets
        : <WalletDbModel>[];
    final categories = context.read<CategoryBloc>().state is CategoryLoaded
        ? (context.read<CategoryBloc>().state as CategoryLoaded).categories
        : <Category>[];
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Container(
        height: mediaQuery.size.height * 0.92,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    widget.category.isIncome ? 'Мои доходы' : 'Мои расходы',
                    style: theme.textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: isValid ? _save : null,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 14),
                      onTap: () => _selectWallet(wallets),
                      title: const Text('Счет'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_selectedWallet.name),
                          const SizedBox(width: 16),
                          const Icon(Icons.chevron_right,
                              color: Color(0x4d3c3c43)),
                        ],
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 14),
                      onTap: () => _selectCategory(categories),
                      title: const Text('Категория'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_selectedCategory.name),
                          const SizedBox(width: 16),
                          const Icon(Icons.chevron_right,
                              color: Color(0x4d3c3c43)),
                        ],
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 14),
                      title: const Text('Сумма'),
                      trailing: SizedBox(
                        width: 120,
                        child: TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          textAlign: TextAlign.right,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 14),
                      onTap: _selectDate,
                      title: const Text('Дата'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              '${_selectedDate.day.toString().padLeft(2, '0')}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.year}'),
                          const SizedBox(width: 16),
                          const Icon(Icons.chevron_right,
                              color: Color(0x4d3c3c43)),
                        ],
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 14),
                      onTap: _selectTime,
                      title: const Text('Время'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_selectedTime.format(context)),
                          const SizedBox(width: 16),
                          const Icon(Icons.chevron_right,
                              color: Color(0x4d3c3c43)),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: 'Комментарий',
                          border:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    isEditMode
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: _delete,
                              child: Text('Удалить'),
                            ),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

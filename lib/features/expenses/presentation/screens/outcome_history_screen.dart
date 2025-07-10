import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bank_accounts/presentation/bloc/operation_bloc.dart';
import '../../../categories/presentation/bloc/category_bloc.dart';
import '../../../categories/domain/entities/category.dart';

class OutcomeHistoryScreen extends StatefulWidget {
  const OutcomeHistoryScreen({super.key});

  @override
  State<OutcomeHistoryScreen> createState() => _OutcomeHistoryScreenState();
}

class _OutcomeHistoryScreenState extends State<OutcomeHistoryScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _sort = 'date'; // 'date' or 'amount'

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История расходов'),
      ),
      body: Column(
        children: [
          _buildFilter(context),
          const Divider(height: 1),
          Expanded(child: _buildHistoryList(context)),
        ],
      ),
    );
  }

  Widget _buildFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _startDate!,
                  firstDate: DateTime(2000),
                  lastDate: _endDate!,
                );
                if (picked != null) setState(() => _startDate = picked);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('С'),
                  Text(
                      '${_startDate!.day.toString().padLeft(2, '0')}.${_startDate!.month.toString().padLeft(2, '0')}.${_startDate!.year}'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _endDate!,
                  firstDate: _startDate!,
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _endDate = picked);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('По'),
                  Text(
                      '${_endDate!.day.toString().padLeft(2, '0')}.${_endDate!.month.toString().padLeft(2, '0')}.${_endDate!.year}'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: _sort,
            items: const [
              DropdownMenuItem(value: 'date', child: Text('По дате')),
              DropdownMenuItem(value: 'amount', child: Text('По сумме')),
            ],
            onChanged: (v) => setState(() => _sort = v!),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    return BlocBuilder<OperationBloc, OperationState>(
      builder: (context, opState) {
        return BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, catState) {
            if (opState is OperationsLoading || catState is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (opState is OperationsLoaded &&
                catState is CategoryLoaded) {
              final categories = {for (var c in catState.categories) c.id: c};
              final ops = opState.operations.where((op) {
                final cat = categories[op.groupId];
                final d = op.operationDate;
                return cat != null &&
                    !cat.isIncome &&
                    d.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
                    d.isBefore(_endDate!.add(const Duration(days: 1)));
              }).toList();
              if (_sort == 'amount') {
                ops.sort((a, b) =>
                    double.parse(b.amount).compareTo(double.parse(a.amount)));
              } else {
                ops.sort((a, b) => b.operationDate.compareTo(a.operationDate));
              }
              if (ops.isEmpty) {
                return const Center(
                    child: Text('Нет расходов за выбранный период'));
              }
              final total = ops.fold<double>(
                  0, (sum, op) => sum + (double.tryParse(op.amount) ?? 0.0));
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Text('Сумма: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(total.toStringAsFixed(2)),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.separated(
                      itemCount: ops.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final op = ops[i];
                        final cat = categories[op.groupId];
                        return ListTile(
                          leading: Text(cat?.emoji ?? '📂',
                              style: const TextStyle(fontSize: 22)),
                          title: Text(cat?.name ?? ''),
                          subtitle: Text(op.comment ?? ''),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(op.amount),
                              Text(
                                  '${op.operationDate.day.toString().padLeft(2, '0')}.${op.operationDate.month.toString().padLeft(2, '0')}.${op.operationDate.year}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (opState is OperationsError) {
              return Center(child: Text('Ошибка: ${opState.message}'));
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}

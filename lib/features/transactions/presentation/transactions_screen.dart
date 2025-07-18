import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/transaction_bloc.dart';
import 'bloc/transaction_event.dart';
import 'bloc/transaction_state.dart';
import '../domain/entities/transaction.dart';

class TransactionsScreen extends StatefulWidget {
  final bool isIncome;
  const TransactionsScreen({super.key, required this.isIncome});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    // Отправляем событие только один раз при открытии экрана
    context.read<TransactionBloc>().add(
          LoadTransactionsEvent(isIncome: widget.isIncome),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isIncome ? 'Доходы' : 'Расходы'),
        backgroundColor: Colors.green,
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionLoaded) {
            // if(state.transactions.isEmpty) {
            //   return const Center(child: Text('Транзакций пока нет'),);
            // }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Всего: ', style: TextStyle(fontSize: 18)),
                      Text(
                        state.total.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.transactions.length,
                    itemBuilder: (context, index) {
                      final t = state.transactions[index];
                      return ListTile(
                        leading: Text(t.category.emoji,
                            style: const TextStyle(fontSize: 24)),
                        title: Text(t.category.name),
                        subtitle: Text(t.comment ?? ''),
                        trailing: Text(
                          t.amount.toStringAsFixed(2),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16)),
                            ),
                            builder: (_) =>
                                HistoryTransactionDetailsModal(transaction: t),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is TransactionError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class HistoryTransactionDetailsModal extends StatelessWidget {
  final Transaction transaction;
  const HistoryTransactionDetailsModal({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.85;
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Text('ID: \\${transaction.id}'),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chart_widget/chart_widget.dart';
import 'dart:math';
import '../../domain/services/transaction_chart_service.dart';
import '../../domain/entities/transaction.dart';

class TransactionChartWidget extends StatefulWidget {
  const TransactionChartWidget({super.key});

  @override
  State<TransactionChartWidget> createState() => _TransactionChartWidgetState();
}

class _TransactionChartWidgetState extends State<TransactionChartWidget> {
  TransactionChartMode _mode = TransactionChartMode.byDay;

  @override
  void initState() {
    super.initState();
    // Загружаем данные при инициализации
    context.read<TransactionChartService>().loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionChartService, TransactionChartState>(
      builder: (context, state) {
        if (state is TransactionChartLoading) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is TransactionChartError) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'Ошибка: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (state is TransactionChartLoaded) {
          final chartData = _buildChartData(state.transactions);

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SegmentedButton<TransactionChartMode>(
                  segments: const [
                    ButtonSegment(
                      value: TransactionChartMode.byDay,
                      label: SizedBox(
                        width: 150,
                        child: Center(child: Text('По дням')),
                      ),
                    ),
                    ButtonSegment(
                      value: TransactionChartMode.byMonth,
                      label: SizedBox(
                        width: 150,
                        child: Center(child: Text('По месяцам')),
                      ),
                    ),
                  ],
                  selected: {_mode},
                  onSelectionChanged: (modes) {
                    if (modes.isNotEmpty) {
                      context
                          .read<TransactionChartService>()
                          .setMode(modes.first);
                      setState(() => _mode = modes.first);
                    }
                  },
                  showSelectedIcon: false,
                ),
              ),
              SizedBox(
                height: 200,
                child: BalanceBarChartWidget(
                  bars: chartData.bars,
                  config: chartData.config,
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  _ChartData _buildChartData(List<Transaction> transactions) {
    final service = context.read<TransactionChartService>();
    final chartData = service.getChartData();

    final bars = chartData
        .map((data) => BalanceBarData(
              x: data.x,
              value: data.value,
              color: data.value >= 0
                  ? const Color(0xFF2AE881)
                  : const Color(0xFFFF5F00),
              label: data.label,
            ))
        .toList();

    final maxValue = bars.isNotEmpty
        ? bars.map((b) => b.value.abs()).reduce(max) * 1.2
        : 10.0;

    final config = BalanceChartConfig(
      minY: 0,
      maxY: maxValue,
      barsCount: bars.length,
      labelX: _getLabelX(bars),
      xLabelFormatter: (x) {
        final bar = bars.firstWhere(
          (b) => b.x == x,
          orElse: () => BalanceBarData(x: x, value: 0, color: Colors.grey),
        );
        return bar.label ?? '';
      },
    );

    return _ChartData(bars, config);
  }

  List<int> _getLabelX(List<BalanceBarData> bars) {
    if (bars.isEmpty) return [];

    if (_mode == TransactionChartMode.byDay) {
      // Показываем метки для 1-го, середины и последнего дня
      final daysInMonth = bars.length;
      return [1, (daysInMonth / 2).round(), daysInMonth];
    } else {
      // Показываем метки для всех месяцев
      return List.generate(bars.length, (i) => i + 1);
    }
  }
}

class _ChartData {
  final List<BalanceBarData> bars;
  final BalanceChartConfig config;

  _ChartData(this.bars, this.config);
}

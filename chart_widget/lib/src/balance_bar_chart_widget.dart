import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BalanceBarData {
  final int x;
  final double value;
  final Color color;
  final String? label;
  BalanceBarData({required this.x, required this.value, required this.color, this.label});
}

class BalanceChartConfig {
  final double minY;
  final double maxY;
  final int barsCount;
  final List<int> labelX;
  final String Function(int x)? xLabelFormatter;
  BalanceChartConfig({required this.minY, required this.maxY, required this.barsCount, required this.labelX, this.xLabelFormatter});
}

class BalanceBarChartWidget extends StatelessWidget {
  final List<BalanceBarData> bars;
  final BalanceChartConfig config;
  const BalanceBarChartWidget({super.key, required this.bars, required this.config});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            barGroups: bars
                .map(
                  (bar) => BarChartGroupData(
                    x: bar.x,
                    barRods: [BarChartRodData(toY: bar.value.abs(), color: bar.color, width: 6, borderRadius: const BorderRadius.all(Radius.circular(92)))],
                  ),
                )
                .toList(),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final x = value.toInt();
                    if (config.labelX.contains(x)) {
                      final label = config.xLabelFormatter?.call(x) ?? x.toString();
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(label, style: const TextStyle(fontSize: 10)),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  reservedSize: 24,
                ),
              ),
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barTouchData: const BarTouchData(enabled: true),
            maxY: config.maxY,
            minY: config.minY,
          ),
        ),
      ),
    );
  }
}

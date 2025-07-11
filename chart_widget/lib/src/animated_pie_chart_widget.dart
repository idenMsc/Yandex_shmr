import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class PieChartSection {
  final String title;
  final double value;
  final Color color;

  PieChartSection({required this.title, required this.value, required this.color});

  @override
  bool operator ==(Object other) => identical(this, other) || other is PieChartSection && runtimeType == other.runtimeType && title == other.title && value == other.value && color == other.color;

  @override
  int get hashCode => title.hashCode ^ value.hashCode ^ color.hashCode;
}

class AnimatedPieChartWidget extends StatefulWidget {
  final List<PieChartSection> data;
  final TextStyle titleStyle;
  final int maxTitles;

  const AnimatedPieChartWidget({super.key, required this.data, required this.titleStyle, this.maxTitles = 3});

  @override
  State<AnimatedPieChartWidget> createState() => _AnimatedPieChartWidgetState();
}

class _AnimatedPieChartWidgetState extends State<AnimatedPieChartWidget> with SingleTickerProviderStateMixin {
  late List<PieChartSection> _oldData;
  late List<PieChartSection> _newData;
  late AnimationController _controller;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _oldData = [];
    _newData = widget.data;
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _isAnimating = true;
    _controller.reset();
    _controller.forward().then((_) {
      setState(() {
        _isAnimating = false;
      });
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedPieChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.data, oldWidget.data)) {
      _oldData = oldWidget.data;
      _newData = widget.data;
      _isAnimating = true;
      _controller.reset();
      _controller.forward().then((_) {
        setState(() {
          _isAnimating = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAnimating && _newData == _oldData) {
      return _buildChart(context, _newData, 0, 1.0);
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = _controller.value * 360;
        final isFirstHalf = _controller.value < 0.5;
        final opacity = isFirstHalf ? 1.0 - _controller.value * 2 : (_controller.value - 0.5) * 2;
        final data = isFirstHalf ? _oldData : _newData;
        return _buildChart(context, data, angle, opacity);
      },
    );
  }

  Widget _buildChart(BuildContext context, List<PieChartSection> data, double angle, double opacity) {
    var titleCount = 0;
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle * 3.1415926 / 180,
        child: Stack(
          alignment: Alignment.center,
          children: [
            PieChart(
              PieChartData(
                startDegreeOffset: -90,
                sections: data
                    .map(
                      (e) => PieChartSectionData(
                        value: e.value,
                        color: e.color,
                        title: '',
                        titleStyle: const TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis),
                        radius: 10,
                      ),
                    )
                    .toList(),
                sectionsSpace: 0,
                centerSpaceRadius: 65,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.map((e) {
                if (titleCount > widget.maxTitles) {
                  titleCount++;
                  return const SizedBox.shrink();
                }
                if (titleCount == widget.maxTitles) {
                  titleCount++;
                  return Text("...", style: widget.titleStyle);
                }
                titleCount++;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(color: e.color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 3),
                      Text('${e.value.toStringAsFixed(0)}% ${e.title}', style: widget.titleStyle),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

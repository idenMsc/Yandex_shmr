import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:shmr_25/widgets/custom_bottom_bar.dart';
import 'package:shmr_25/widgets/tab_item_data.dart';

void main() {
  testGoldens('CustomBottomBar golden test', (WidgetTester tester) async {
    final tabs = [
      const TabItemData(icon: Icons.home, label: 'Home'),
      const TabItemData(icon: Icons.search, label: 'Search'),
      const TabItemData(icon: Icons.person, label: 'Profile'),
    ];
    await tester.pumpWidgetBuilder(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomBar(
              tabs: tabs,
              selectedIndex: 1,
              onTabSelected: (_) {},
            ),
          ),
        ),
      ),
      surfaceSize: const Size(400, 100),
    );
    await screenMatchesGolden(tester, 'custom_bottom_bar_golden');
  });
} 
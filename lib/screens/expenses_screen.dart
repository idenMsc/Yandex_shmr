import 'package:flutter/material.dart';
import '../widgets/custom_bottom_bar.dart';
import '../widgets/expense_item.dart';
import '../widgets/tab_item_data.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../features/transactions/presentation/transactions_screen.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  int _selectedTab = 0;

  final List<TabItemData> _tabs = const [
    TabItemData(
      icon: Icons.show_chart,
      label: 'Расходы',
    ),
    TabItemData(
      assetPath: "assets/images/Dohody_item.svg",
      label: 'Доходы',
    ),
    TabItemData(
      icon: Icons.calculate,
      label: 'Счет',
    ),
    TabItemData(
      icon: Icons.format_align_left,
      label: 'Статьи',
    ),
    TabItemData(
      icon: Icons.settings,
      label: 'Настройки',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Мои расходы"),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: _buildTabContent(_selectedTab),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomBar(
        tabs: _tabs,
        selectedIndex: _selectedTab,
        onTabSelected: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
      ),
    );
  }

  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return const TransactionsScreen(isIncome: false);
      case 1:
        return const TransactionsScreen(isIncome: true);
      case 2:
        return const Center(child: Text('Счет'));
      case 3:
        return const Center(child: Text('Статьи'));
      case 4:
        return const Center(child: Text('Настройки'));
      default:
        return Container();
    }
  }
}

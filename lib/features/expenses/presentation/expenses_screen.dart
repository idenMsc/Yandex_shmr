import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'custom_bottom_bar.dart';
import 'tab_item_data.dart';
import '../../../gen/assets.gen.dart';
import '../../bank_accounts/presentation/account_screen.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  int _selectedTab = 0;

  final List<TabItemData> _tabs = [
    TabItemData(
      assetPath: Assets.icons.trendDown,
      label: 'Расходы',
    ),
    TabItemData(
      assetPath: Assets.icons.trendUp,
      label: 'Доходы',
    ),
    TabItemData(
      assetPath: Assets.icons.account,
      label: 'Счет',
    ),
    TabItemData(
      assetPath: Assets.icons.expenseStats,
      label: 'Статьи',
    ),
    TabItemData(
      assetPath: Assets.icons.settings,
      label: 'Настройки',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabs[_selectedTab].label),
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
        return ListView(
          children: const [
            ExpenseItem(icon: Icons.home, label: "Аренда", amount: "50 000 ₽"),
            ExpenseItem(
                icon: Icons.fastfood, label: "Продукты", amount: "8 000 ₽"),
            ExpenseItem(
                icon: Icons.sports, label: "Спортзал", amount: "3 000 ₽"),
          ],
        );
      case 1:
        return ListView(
          children: const [
            ExpenseItem(
                icon: Icons.work, label: "Зарплата", amount: "150 000 ₽"),
            ExpenseItem(
                icon: Icons.card_giftcard, label: "Подарки", amount: "5 000 ₽"),
          ],
        );
      case 2:
        return const AccountScreen();
      case 3:
        return const Center(child: Text('Статьи'));
      case 4:
        return const Center(child: Text('Настройки'));
      default:
        return Container();
    }
  }
}

class ExpenseItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;

  const ExpenseItem({
    super.key,
    required this.icon,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green[100],
        child: Icon(icon, color: Colors.green[800]),
      ),
      title: Text(label),
      trailing: Text(
        amount,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

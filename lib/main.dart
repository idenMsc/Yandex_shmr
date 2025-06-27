import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SHMR Finance',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ExpensesScreen(),
    );
  }
}

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  int _selectedTab = 0;

  final List<_TabItemData> _tabs = const [
    _TabItemData(
      icon: Icons.show_chart,
      label: 'Расходы',
    ),
    _TabItemData(
      assetPath: "assets/images/Dohody_item.svg",
      label: 'Доходы',
    ),
    _TabItemData(
      icon: Icons.calculate,
      label: 'Счет',
    ),
    _TabItemData(
      icon: Icons.format_align_left,
      label: 'Статьи',
    ),
    _TabItemData(
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
      bottomNavigationBar: _CustomBottomBar(
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
        return Center(child: Text('Счет'));
      case 3:
        return Center(child: Text('Статьи'));
      case 4:
        return Center(child: Text('Настройки'));
      default:
        return Container();
    }
  }
}

class _TabItemData {
  final IconData? icon;
  final String label;
  final String? assetPath;
  const _TabItemData({this.icon, required this.label, this.assetPath});
}

class _CustomBottomBar extends StatelessWidget {
  final List<_TabItemData> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const _CustomBottomBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F4FA),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFDFFFE2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    tabs[index].assetPath != null
                        ? (tabs[index].assetPath!.endsWith('.svg')
                            ? SvgPicture.asset(
                                tabs[index].assetPath!,
                                height: 32,
                                width: 32,
                                // colorFilter: ColorFilter.mode(
                                //   isSelected ? Colors.green : Colors.grey[700]!,
                                //   BlendMode.srcIn,
                                // ),
                              )
                            : Image.asset(
                                tabs[index].assetPath!,
                                height: 32,
                                width: 32,
                                color: isSelected
                                    ? Colors.green
                                    : Colors.grey[700],
                              ))
                        : Icon(
                            tabs[index].icon,
                            color: isSelected ? Colors.green : Colors.grey[700],
                            size: 32,
                          ),
                    const SizedBox(height: 4),
                    Text(
                      tabs[index].label,
                      style: TextStyle(
                        color: isSelected ? Colors.green : Colors.grey[700],
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
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

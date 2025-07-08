import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shmr_25/features/expenses/presentation/widgets/expenses_item_widget.dart';
import 'package:shmr_25/widgets/appSvg.dart';
import '../../../categories/presentation/pages/categories_page.dart';
import '../custom_bottom_bar.dart';
import '../tab_item_data.dart';
import '../../../../gen/assets.gen.dart';
import '../../../bank_accounts/presentation/account_screen.dart';
import '../../../../core/utils/constants.dart';
import '../../../../injection_container.dart' as di;
import '../../../bank_accounts/presentation/bloc/wallet_bloc.dart';
import '../../../bank_accounts/presentation/bloc/operation_bloc.dart';
import '../../../transactions/presentation/operation_edit_screen.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  int _selectedTab = 0;

  void _editAccountTitle() async {
    final walletBloc = context.read<WalletBloc>();
    final wallets = walletBloc.state;
    if (wallets is! WalletsLoaded || wallets.wallets.isEmpty) return;

    final controller = TextEditingController(text: wallets.wallets.first.name);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('SHMR Finance'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Счет',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      // Обновляем название кошелька через BLoC
      walletBloc.add(UpdateWalletName(wallets.wallets.first.id, result));
    }
  }

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<WalletBloc>(
          create: (context) => di.sl<WalletBloc>(),
        ),
        BlocProvider<OperationBloc>(
          create: (context) => di.sl<OperationBloc>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: _selectedTab == 2
              ? BlocBuilder<WalletBloc, WalletState>(
                  builder: (context, state) {
                    if (state is WalletsLoaded && state.wallets.isNotEmpty) {
                      return Text(state.wallets.first.name,
                          style: AppTextStyles.titleLarge);
                    }
                    return Text('Счет', style: AppTextStyles.titleLarge);
                  },
                )
              : Text(_tabs[_selectedTab].label,
                  style: AppTextStyles.titleLarge),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          elevation: 0,
          toolbarHeight: AppSizes.appBarHeight,
          actions: _selectedTab == 2
              ? [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/edit.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.onSurfaceVariant,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: _editAccountTitle,
                  ),
                ]
              : [Container()],
          actionsIconTheme: const IconThemeData(size: 24),
          actionsPadding: const EdgeInsets.only(right: 4),
        ),
        body: _buildTabContent(_selectedTab),
        floatingActionButton: (_selectedTab == 0 || _selectedTab == 1)
            ? FloatingActionButton(
          backgroundColor: const Color.fromRGBO(42, 232, 129, 1),
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          elevation: 0,
          hoverElevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          disabledElevation: 0,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OperationEditScreen(
                isIncome: _selectedTab == 1,
              ),
            ),
          ),
          child: SvgPicture.asset('assets/icons/plus.svg', width: 24,
            height: 24),
        )
            : null,
        bottomNavigationBar: CustomBottomBar(
          tabs: _tabs,
          selectedIndex: _selectedTab,
          onTabSelected: (index) {
            setState(() {
              _selectedTab = index;
            });
          },
        ),
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
        return AccountScreen();
      case 3:
        return CategoriesPage();
      case 4:
        return const Center(child: Text('Настройки'));
      default:
        return Container();
    }
  }
}



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shmr_25/features/expenses/presentation/widgets/expenses_item_widget.dart';
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
import '../../../categories/presentation/bloc/category_bloc.dart';

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
        BlocProvider<CategoryBloc>(
          create: (context) => di.sl<CategoryBloc>()..add(LoadCategories()),
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
                onPressed: () => OperationEditModal.show(
                  context,
                  isIncome: _selectedTab == 1,
                ),
                child: SvgPicture.asset('assets/icons/plus.svg',
                    width: 24, height: 24),
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
        return ExpensesTodayList();
      case 1:
        return IncomeTodayList();
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

// Добавляю виджеты для отображения операций за сегодня
class ExpensesTodayList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OperationBloc, OperationState>(
      builder: (context, state) {
        return BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, catState) {
            if (state is OperationsLoading || catState is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OperationsLoaded &&
                catState is CategoryLoaded) {
              final categories = {for (var c in catState.categories) c.id: c};
              final today = DateTime.now();
              final todayOps = state.operations.where((op) {
                final d = op.operationDate;
                final cat = categories[op.groupId];
                return cat != null &&
                    !cat.isIncome &&
                    d.year == today.year &&
                    d.month == today.month &&
                    d.day == today.day;
              }).toList();
              if (todayOps.isEmpty) {
                return const Center(child: Text('Нет расходов за сегодня'));
              }
              return ListView.separated(
                itemCount: todayOps.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, i) {
                  final op = todayOps[i];
                  return ListTile(
                    leading: const Icon(Icons.trending_down),
                    title: Text(op.amount),
                    subtitle: Text(op.comment ?? ''),
                    trailing: Text(
                        '${op.operationDate.hour.toString().padLeft(2, '0')}:${op.operationDate.minute.toString().padLeft(2, '0')}'),
                  );
                },
              );
            } else if (state is OperationsError) {
              return Center(child: Text('Ошибка: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}

class IncomeTodayList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OperationBloc, OperationState>(
      builder: (context, state) {
        return BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, catState) {
            if (state is OperationsLoading || catState is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OperationsLoaded &&
                catState is CategoryLoaded) {
              final categories = {for (var c in catState.categories) c.id: c};
              final today = DateTime.now();
              final todayOps = state.operations.where((op) {
                final d = op.operationDate;
                final cat = categories[op.groupId];
                return cat != null &&
                    cat.isIncome &&
                    d.year == today.year &&
                    d.month == today.month &&
                    d.day == today.day;
              }).toList();
              if (todayOps.isEmpty) {
                return const Center(child: Text('Нет доходов за сегодня'));
              }
              return ListView.separated(
                itemCount: todayOps.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, i) {
                  final op = todayOps[i];
                  return ListTile(
                    leading: const Icon(Icons.trending_up),
                    title: Text(op.amount),
                    subtitle: Text(op.comment ?? ''),
                    trailing: Text(
                        '${op.operationDate.hour.toString().padLeft(2, '0')}:${op.operationDate.minute.toString().padLeft(2, '0')}'),
                  );
                },
              );
            } else if (state is OperationsError) {
              return Center(child: Text('Ошибка: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}

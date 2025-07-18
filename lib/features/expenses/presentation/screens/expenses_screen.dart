import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../categories/presentation/pages/categories_page.dart';
import '../../../transactions/presentation/transaction_create_modal.dart';
import '../custom_bottom_bar.dart';
import '../tab_item_data.dart';
import '../../../../gen/assets.gen.dart';
import '../../../bank_accounts/presentation/account_screen.dart';
import '../../../../core/utils/constants.dart';
import '../../../bank_accounts/presentation/bloc/wallet_bloc.dart';
import '../../../bank_accounts/presentation/bloc/operation_bloc.dart';
import '../../../transactions/presentation/operation_edit_screen.dart';
import '../../../categories/presentation/bloc/category_bloc.dart';
import 'outcome_history_screen.dart';
import 'income_history_screen.dart';
import '../../../transactions/presentation/bloc/transaction_bloc.dart';
import '../../../transactions/presentation/bloc/transaction_state.dart';
import '../../../transactions/presentation/bloc/transaction_event.dart';
import 'package:shmr_25/widgets/offline_indicator.dart';
import '../../../settings/settings_screen.dart';
import '../../../settings/settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../l10n/app_localizations.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  int _selectedTab = 0;

  List<TabItemData> _tabs = [];

  @override
  void initState() {
    super.initState();
    _loadSelectedTab();
    // Гарантируем, что кошельки всегда загружены
    context.read<WalletBloc>().add(LoadWallets());
    // Гарантируем, что операции всегда загружены
    context.read<OperationBloc>().add(LoadOperations());
  }

  Future<void> _loadSelectedTab() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTab = prefs.getInt('selectedTab') ?? 0;
    setState(() {
      _selectedTab = savedTab;
    });
  }

  void _editAccountTitle() async {
    final walletBloc = context.read<WalletBloc>();
    final wallets = walletBloc.state;
    if (wallets is! WalletsLoaded || wallets.wallets.isEmpty) return;

    final controller = TextEditingController(text: wallets.wallets.first.name);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SHMR Finance'),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    _tabs = [
      TabItemData(
        assetPath: Assets.icons.trendDown,
        label: l10n.tabExpenses,
      ),
      TabItemData(
        assetPath: Assets.icons.trendUp,
        label: l10n.tabIncome,
      ),
      TabItemData(
        assetPath: Assets.icons.account,
        label: l10n.tabAccount,
      ),
      TabItemData(
        assetPath: Assets.icons.expenseStats,
        label: l10n.tabStats,
      ),
      TabItemData(
        assetPath: Assets.icons.settings,
        label: l10n.tabSettings,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: _selectedTab == 2
            ? BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  if (state is WalletsLoaded && state.wallets.isNotEmpty) {
                    return Text(state.wallets.first.name,
                        style: AppTextStyles.titleLarge);
                  }
                  return Text(l10n.tabAccount, style: AppTextStyles.titleLarge);
                },
              )
            : Text(_tabs[_selectedTab].label, style: AppTextStyles.titleLarge),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        toolbarHeight: AppSizes.appBarHeight,
        actions: _selectedTab == 0 || _selectedTab == 1
            ? [
                IconButton(
                  icon: const Icon(Icons.history),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => _selectedTab == 1
                            ? IncomeHistoryScreen()
                            : OutcomeHistoryScreen(),
                      ),
                    );
                  },
                ),
              ]
            : _selectedTab == 2
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
              onPressed: () => TransactionCreateModal.show(
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
        onTabSelected: (index) async {
          setState(() {
            _selectedTab = index;
          });
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('selectedTab', index);
          // Перезагружаем транзакции при переключении табов
          if (index == 0) {
            context
                .read<TransactionBloc>()
                .add(LoadTransactionsEvent(isIncome: false));
          } else if (index == 1) {
            context
                .read<TransactionBloc>()
                .add(LoadTransactionsEvent(isIncome: true));
          }
        },
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
        return const AccountScreen();
      case 3:
        return const CategoriesPage();
      case 4:
        return const SettingsScreen();
      default:
        return Container();
    }
  }
}

// Добавляю виджеты для отображения операций за сегодня
class ExpensesTodayList extends StatefulWidget {
  @override
  State<ExpensesTodayList> createState() => _ExpensesTodayListState();
}

class _ExpensesTodayListState extends State<ExpensesTodayList> {
  @override
  void initState() {
    super.initState();
    // Загружаем транзакции при инициализации
    context.read<TransactionBloc>().add(LoadTransactionsEvent(isIncome: false));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TransactionLoaded) {
          if (state.transactions.isEmpty) {
            return Center(
                child: Text(AppLocalizations.of(context)!.noExpensesToday));
          }
          return ListView.separated(
            itemCount: state.transactions.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, i) {
              final transaction = state.transactions[i];
              return ListTile(
                leading: Text(transaction.category.emoji,
                    style: const TextStyle(fontSize: 24)),
                title: Text(transaction.amount.toStringAsFixed(2)),
                subtitle: Text(transaction.comment ?? ''),
                trailing: Text(
                    '${transaction.transactionDate.hour.toString().padLeft(2, '0')}:${transaction.transactionDate.minute.toString().padLeft(2, '0')}'),
              );
            },
          );
        } else if (state is TransactionError) {
          return Center(child: Text('Ошибка: ${state.message}'));
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class IncomeTodayList extends StatefulWidget {
  @override
  State<IncomeTodayList> createState() => _IncomeTodayListState();
}

class _IncomeTodayListState extends State<IncomeTodayList> {
  @override
  void initState() {
    super.initState();
    // Загружаем транзакции при инициализации
    context.read<TransactionBloc>().add(LoadTransactionsEvent(isIncome: true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TransactionLoaded) {
          if (state.transactions.isEmpty) {
            return const Center(child: Text('Нет доходов за сегодня'));
          }
          return ListView.separated(
            itemCount: state.transactions.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, i) {
              final transaction = state.transactions[i];
              return ListTile(
                leading: Text(transaction.category.emoji,
                    style: const TextStyle(fontSize: 24)),
                title: Text(transaction.amount.toStringAsFixed(2)),
                subtitle: Text(transaction.comment ?? ''),
                trailing: Text(
                    '${transaction.transactionDate.hour.toString().padLeft(2, '0')}:${transaction.transactionDate.minute.toString().padLeft(2, '0')}'),
              );
            },
          );
        } else if (state is TransactionError) {
          return Center(child: Text('Ошибка: ${state.message}'));
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// Экран истории операций
class OperationHistoryScreen extends StatelessWidget {
  final bool isIncome;
  const OperationHistoryScreen({Key? key, required this.isIncome})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isIncome ? 'История доходов' : 'История расходов'),
      ),
      body: BlocBuilder<OperationBloc, OperationState>(
        builder: (context, state) {
          return BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, catState) {
              if (state is OperationsLoading || catState is CategoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OperationsLoaded &&
                  catState is CategoryLoaded) {
                final categories = {for (var c in catState.categories) c.id: c};
                final ops = state.operations.where((op) {
                  final cat = categories[op.groupId];
                  return cat != null && cat.isIncome == isIncome;
                }).toList();
                if (ops.isEmpty) {
                  return Center(
                      child: Text(isIncome ? 'Нет доходов' : 'Нет расходов'));
                }
                return ListView.separated(
                  itemCount: ops.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, i) {
                    final op = ops[i];
                    final cat = categories[op.groupId];
                    return ListTile(
                      leading: Text(cat?.emoji ?? ''),
                      title: Text(cat?.name ?? ''),
                      subtitle: Text(op.comment ?? ''),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(op.amount),
                          Text(
                              '${op.operationDate.day.toString().padLeft(2, '0')}.${op.operationDate.month.toString().padLeft(2, '0')}.${op.operationDate.year}'),
                        ],
                      ),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/utils/constants.dart';
import '../../../l10n/app_localizations.dart';
import 'bloc/wallet_bloc.dart';
import 'bloc/operation_bloc.dart';
import '../../transactions/presentation/operation_edit_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool showBalance = true;
  String selectedCurrency = '₽';

  @override
  void initState() {
    super.initState();
    // Загружаем данные при инициализации
    context.read<WalletBloc>().add(LoadWallets());
    context.read<OperationBloc>().add(LoadOperations());
  }

  void _toggleBalance() {
    setState(() {
      showBalance = !showBalance;
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
        title: Text(AppLocalizations.of(context)!.appTitle),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.navBarAccount,
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

  void _selectCurrency() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => ListView(
        children: [
          ListTile(
            title: const Text('₽ (RUB)'),
            onTap: () => Navigator.pop(context, '₽'),
          ),
          ListTile(
            title: const Text(' 24 (USD)'),
            onTap: () => Navigator.pop(context, ' 24'),
          ),
          ListTile(
            title: const Text('€ (EUR)'),
            onTap: () => Navigator.pop(context, '€'),
          ),
        ],
      ),
    );
    if (result != null) {
      setState(() {
        selectedCurrency = result;
      });
      // Обновляем валюту кошелька через BLoC
      final walletBloc = context.read<WalletBloc>();
      final wallets = walletBloc.state;
      if (wallets is WalletsLoaded && wallets.wallets.isNotEmpty) {
        walletBloc.add(UpdateWalletCurrency(wallets.wallets.first.id, result));
      }
    }
  }

  String _getCategoryFromGroupId(int groupId, bool isIncome) {
    if (isIncome) {
      switch (groupId) {
        case 1:
          return 'Зарплата';
        case 2:
          return 'Подарки';
        case 3:
          return 'Инвестиции';
        default:
          return 'Другое';
      }
    } else {
      switch (groupId) {
        case 4:
          return 'Продукты';
        case 5:
          return 'Транспорт';
        case 6:
          return 'Развлечения';
        case 7:
          return 'Одежда';
        case 8:
          return 'Здоровье';
        default:
          return 'Другое';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            if (state is WalletsLoading) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (state is WalletsLoaded && state.wallets.isNotEmpty) {
              final wallet = state.wallets.first;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: AppSizes.avatarRadius,
                      child: const Text('💰'),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      AppLocalizations.of(context)!.total,
                      style: AppTextStyles.bodyLarge,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _toggleBalance,
                      child: AnimatedOpacity(
                        opacity: showBalance ? 1 : 0.3,
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          showBalance
                              ? '${wallet.balance} ${wallet.currency}'
                              : '••••••',
                          style: AppTextStyles.bodyLarge,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SvgPicture.asset(
                      'assets/icons/more_vert.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.tertiary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is WalletsError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Ошибка: ${state.message}',
                  style:
                      AppTextStyles.bodyLarge.copyWith(color: AppColors.error),
                ),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Нет данных о кошельке'),
              );
            }
          },
        ),
        ListTile(
          onTap: _selectCurrency,
          leading: Text(
            AppLocalizations.of(context)!.navBarAccount,
            style: AppTextStyles.bodyLarge,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  if (state is WalletsLoaded && state.wallets.isNotEmpty) {
                    return Text(state.wallets.first.currency,
                        style: AppTextStyles.bodyLarge);
                  }
                  return Text(selectedCurrency, style: AppTextStyles.bodyLarge);
                },
              ),
              const SizedBox(width: 8),
              SvgPicture.asset(
                'assets/icons/more_vert.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.tertiary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<OperationBloc, OperationState>(
            builder: (context, state) {
              if (state is OperationsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OperationsLoaded) {
                if (state.operations.isEmpty) {
                  return const Center(
                    child: Text('Нет операций'),
                  );
                }
                return ListView.builder(
                  itemCount: state.operations.length,
                  itemBuilder: (context, index) {
                    final operation = state.operations[index];
                    final isIncome =
                        operation.groupId <= 3; // 1-3 доходы, 4+ расходы
                    final category =
                        _getCategoryFromGroupId(operation.groupId, isIncome);

                    return ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OperationEditScreen(
                            initialOperation: operation,
                            isIncome: isIncome,
                          ),
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: isIncome ? Colors.green : Colors.red,
                        child: Icon(
                          isIncome ? Icons.trending_up : Icons.trending_down,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(category),
                      subtitle: Text(operation.comment ?? ''),
                      trailing: Text(
                        '${operation.amount} ₽',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isIncome ? Colors.green : Colors.red,
                        ),
                      ),
                    );
                  },
                );
              } else if (state is OperationsError) {
                return Center(
                  child: Text(
                    'Ошибка: ${state.message}',
                    style: AppTextStyles.bodyLarge
                        .copyWith(color: AppColors.error),
                  ),
                );
              } else {
                return const Center(child: Text('Загрузка операций...'));
              }
            },
          ),
        ),
      ],
    );
  }
}

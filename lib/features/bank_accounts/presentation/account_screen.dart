import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/utils/constants.dart';
import '../../../l10n/app_localizations.dart';
import 'bloc/wallet_bloc.dart';
import 'bloc/operation_bloc.dart';
import '../../transactions/presentation/widgets/transaction_chart_widget.dart';
import '../../transactions/domain/services/transaction_chart_service.dart';
import '../../transactions/data/transaction_repository_impl.dart';
import '../../transactions/data/account_remote_data_source.dart';
import '../../../injection_container.dart';

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
            title: const Text(' 24 (USD)'),
            onTap: () => Navigator.pop(context, ' 24'),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider<TransactionChartService>(
      create: (context) => TransactionChartService(
        transactionRepository: sl<TransactionRepositoryImpl>(),
        accountRemoteDataSource: sl<AccountRemoteDataSource>(),
      ),
      child: Scaffold(
        body: Column(
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
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: AppSizes.avatarRadius,
                          child: Text('💰'),
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
                      style: AppTextStyles.bodyLarge
                          .copyWith(color: AppColors.error),
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
                      return Text(selectedCurrency,
                          style: AppTextStyles.bodyLarge);
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
            // График транзакций
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: TransactionChartWidget(),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

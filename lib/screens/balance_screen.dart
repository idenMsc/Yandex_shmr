import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/utils/constants.dart';
import '../l10n/app_localizations.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  String accountName = 'Мой счет';
  bool isBalanceVisible = true;
  String currency = '₽';
  double balance = 123456.78;

  void _toggleBalanceVisibility() {
    setState(() {
      isBalanceVisible = !isBalanceVisible;
    });
  }

  void _showEditAccountNameDialog() async {
    final controller = TextEditingController(text: accountName);
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
      setState(() {
        accountName = result;
      });
    }
  }

  void _showCurrencySelector() async {
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
        currency = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(AppSizes.appBarHeight),
        child: AppBar(
          title: Text(accountName, style: AppTextStyles.titleLarge),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          elevation: 0,
          actions: [
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
              onPressed: _showEditAccountNameDialog,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
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
                  onTap: _toggleBalanceVisibility,
                  child: AnimatedOpacity(
                    opacity: isBalanceVisible ? 1 : 0.3,
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      isBalanceVisible
                          ? '${balance.toStringAsFixed(2)} $currency'
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
          ),
          ListTile(
            onTap: _showCurrencySelector,
            leading: Text(
              AppLocalizations.of(context)!.navBarAccount,
              style: AppTextStyles.bodyLarge,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(currency, style: AppTextStyles.bodyLarge),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}

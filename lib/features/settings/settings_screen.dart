import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/app_localizations.dart';
import 'settings_cubit.dart';
import '../../core/utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      body: ListView(
        children: [
          const _ThemeSwitcher(),
          const Divider(),
          const _TintPicker(),
          const Divider(),
          ListTile(
            title: Text('Звуки', style: theme.textTheme.bodyLarge),
            onTap: () {},
            trailing: const Icon(Icons.chevron_right, color: Color(0x4d3c3c43)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
          ),
          const Divider(),
          const _HapticsSwitcher(),
          const Divider(),
          const _PasscodeSettings(),
          const Divider(),
          ListTile(
            title: Text('Синхронизация', style: theme.textTheme.bodyLarge),
            onTap: () {},
            trailing: const Icon(Icons.chevron_right, color: Color(0x4d3c3c43)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
          ),
          const Divider(),
          const _LanguagePicker(),
          const Divider(),
          ListTile(
            title: Text('О программе', style: theme.textTheme.bodyLarge),
            onTap: () {},
            trailing: const Icon(Icons.chevron_right, color: Color(0x4d3c3c43)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
          ),
        ],
      ),
    );
  }
}

class _ThemeSwitcher extends StatelessWidget {
  const _ThemeSwitcher();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return ListTile(
          title: const Text('Системная тема'),
          trailing: Switch(
            value: state.useSystemTheme,
            activeColor: AppColors.primary,
            onChanged: (val) =>
                context.read<SettingsCubit>().toggleSystemTheme(),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
        );
      },
    );
  }
}

class _TintPicker extends StatelessWidget {
  const _TintPicker();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Основной цвет'),
      trailing: const Icon(Icons.chevron_right, color: Color(0x4d3c3c43)),
      onTap: () {}, // TODO: реализовать выбор цвета
      contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
    );
  }
}

class _HapticsSwitcher extends StatelessWidget {
  const _HapticsSwitcher();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Хаптики'),
      trailing: const Icon(Icons.chevron_right, color: Color(0x4d3c3c43)),
      onTap: () {}, // TODO: реализовать настройку хаптик
      contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
    );
  }
}

class _PasscodeSettings extends StatelessWidget {
  const _PasscodeSettings();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Код-пароль'),
      trailing: const Icon(Icons.chevron_right, color: Color(0x4d3c3c43)),
      onTap: () {}, // TODO: реализовать настройку пароля
      contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Язык'),
      trailing: const Icon(Icons.chevron_right, color: Color(0x4d3c3c43)),
      onTap: () {}, // TODO: реализовать выбор языка
      contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
    );
  }
}

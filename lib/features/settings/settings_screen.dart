import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/app_localizations.dart';
import 'settings_cubit.dart';
import '../../core/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_cubit.dart';
import 'pin_code_screen.dart';
import 'pin_code_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
            title: Text(l10n.sounds, style: theme.textTheme.bodyLarge),
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
            title: Text(l10n.sync, style: theme.textTheme.bodyLarge),
            onTap: () {},
            trailing: const Icon(Icons.chevron_right, color: Color(0x4d3c3c43)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
          ),
          const Divider(),
          const _LanguagePicker(),
          const Divider(),
          ListTile(
            title: Text(l10n.about, style: theme.textTheme.bodyLarge),
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
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return ListTile(
          title: Text(l10n.darkTheme),
          trailing: Switch(
            value: state.isDarkTheme,
            activeColor: AppColors.primary,
            onChanged: (_) => context.read<SettingsCubit>().toggleTheme(),
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
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return ListTile(
          title: Text(l10n.mainColor),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: state.tintColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Color(0x4d3c3c43)),
            ],
          ),
          onTap: () => _showColorPicker(context),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
        );
      },
    );
  }

  void _showColorPicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Color currentColor = context.read<SettingsCubit>().state.tintColor;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.mainColor,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ColorPicker(
                  pickerColor: currentColor,
                  onColorChanged: (color) {
                    setState(() {
                      currentColor = color;
                    });
                  },
                  colorPickerWidth: MediaQuery.of(context).size.width * 0.9,
                  pickerAreaHeightPercent: 0.7,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.cancel),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<SettingsCubit>()
                            .setTintColor(currentColor);
                        Navigator.pop(context);
                      },
                      child: Text(l10n.done),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HapticsSwitcher extends StatelessWidget {
  const _HapticsSwitcher();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return ListTile(
          title: Text(l10n.haptics),
          trailing: Switch(
            value: state.isHapticsEnabled,
            activeColor: AppColors.primary,
            onChanged: (value) {
              HapticFeedback.heavyImpact();
              context.read<SettingsCubit>().toggleHaptics();
            },
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
        );
      },
    );
  }
}

class _PasscodeSettings extends StatelessWidget {
  const _PasscodeSettings();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      title: Text(l10n.passcode),
      trailing: const Icon(Icons.chevron_right, color: Color(0x4d3c3c43)),
      onTap: () => _showPasscodeSheet(context),
      contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
    );
  }

  void _showPasscodeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const PasscodeSettingsSheet(),
    );
  }
}

class PasscodeSettingsSheet extends StatefulWidget {
  const PasscodeSettingsSheet({super.key});

  @override
  State<PasscodeSettingsSheet> createState() => _PasscodeSettingsSheetState();
}

class _PasscodeSettingsSheetState extends State<PasscodeSettingsSheet> {
  bool _hasPin = false;
  bool _loading = true;
  bool _biometricEnabled = false;
  bool _biometricAvailable = false;
  final _service = PinCodeService();
  final _biometricService = BiometricService();

  @override
  void initState() {
    super.initState();
    _checkPin();
    _checkBiometric();
  }

  Future<void> _checkPin() async {
    final hasPin = await _service.hasPin();
    setState(() {
      _hasPin = hasPin;
      _loading = false;
    });
    if (hasPin) {
      _checkBiometric();
    }
  }

  Future<void> _checkBiometric() async {
    final available = await _biometricService.isBiometricAvailable();
    final enabled = await _biometricService.isBiometricEnabled();
    setState(() {
      _biometricAvailable = available;
      _biometricEnabled = enabled;
    });
  }

  Future<void> _toggleBiometric(bool value) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    if (value) {
      final available = await _biometricService.isBiometricAvailable();
      if (!available) {
        messenger.showSnackBar(
          SnackBar(content: Text('Биометрия недоступна на этом устройстве')),
        );
        return;
      }
    }
    await _biometricService.setBiometricEnabled(value);
    setState(() {
      _biometricEnabled = value;
    });
  }

  void _setPin() async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) =>
            PinCodeScreen(mode: PinCodeMode.set, onSuccess: _checkPin),
      ),
    );
  }

  void _changePin() async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) =>
            PinCodeScreen(mode: PinCodeMode.set, onSuccess: _checkPin),
      ),
    );
  }

  void _deletePin() async {
    await _service.deletePin();
    _checkPin();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                  _hasPin ? 'Изменить код-пароль' : 'Установить код-пароль',
                  style: theme.textTheme.bodyLarge),
              trailing:
                  const Icon(Icons.chevron_right, color: Color(0x4d3c3c43)),
              onTap: _hasPin ? _changePin : _setPin,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
              subtitle: Text(_hasPin
                  ? 'Код-пароль установлен'
                  : 'Код-пароль не установлен'),
            ),
            if (_hasPin)
              ListTile(
                title: const Text('Удалить код-пароль'),
                leading: const Icon(Icons.delete, color: Colors.red),
                onTap: _deletePin,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
              ),
            if (_hasPin && _biometricAvailable)
              SwitchListTile(
                title: const Text('Разблокировка по биометрии'),
                value: _biometricEnabled,
                onChanged: _toggleBiometric,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
              ),
          ],
        ),
      ),
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      title: Text(l10n.language),
      trailing: const Icon(Icons.chevron_right, color: Color(0x4d3c3c43)),
      onTap: () => _showLanguageBottomSheet(context),
      contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCubit = context.read<LanguageCubit>();
    final currentLocale = languageCubit.state.locale;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Русский'),
              trailing: currentLocale.languageCode == 'ru'
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                languageCubit.setLocale(const Locale('ru'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English'),
              trailing: currentLocale.languageCode == 'en'
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                languageCubit.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

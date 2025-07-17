import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../../core/utils/constants.dart';
import '../../widgets/CustomListItem.dart';
import 'settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final settings = [
      'Тёмная тема',
      'Основной цвет',
      'Звуки',
      'Хаптики',
      'Код-пароль',
      'Синхронизация',
      'Язык',
      'О программе',
    ];
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: settings.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // TODO: обработка нажатий для остальных пунктов
                  },
                  child: index == 0
                      ? BlocBuilder<SettingsCubit, SettingsState>(
                          builder: (context, state) {
                            return CustomListItem(
                              height: h * 0.06,
                              paddingLeft: w * 0.02,
                              paddingRight: w * 0.02,
                              title: settings[index],
                              trailing: Switch(
                                value: state.isDarkTheme,
                                activeColor: AppColors.primary,
                                onChanged: (val) =>
                                    context.read<SettingsCubit>().toggleTheme(),
                              ),
                              bgColor: AppColors.surface,
                              wrapEmoji: true,
                              // emoji: '🌙', // Можно добавить emoji или иконку
                            );
                          },
                        )
                      : CustomListItem(
                          height: h * 0.06,
                          paddingLeft: w * 0.02,
                          paddingRight: w * 0.02,
                          title: settings[index],
                          trailing: const Icon(Icons.arrow_right,
                              color: AppColors.onSurfaceVariant),
                          bgColor: AppColors.surface,
                          wrapEmoji: true,
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

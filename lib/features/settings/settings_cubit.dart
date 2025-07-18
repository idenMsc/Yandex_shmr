import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/constants.dart';

class SettingsState {
  final bool isDarkTheme;
  final Color tintColor;
  SettingsState({required this.isDarkTheme, required this.tintColor});

  SettingsState copyWith({bool? isDarkTheme, Color? tintColor}) =>
      SettingsState(
        isDarkTheme: isDarkTheme ?? this.isDarkTheme,
        tintColor: tintColor ?? this.tintColor,
      );
}

class SettingsCubit extends Cubit<SettingsState> {
  static const _keyTheme = 'isDarkTheme';
  static const _keyTint = 'tintColor';
  SettingsCubit()
      : super(SettingsState(isDarkTheme: false, tintColor: AppColors.primary));

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    bool isDark;
    if (prefs.containsKey(_keyTheme)) {
      isDark = prefs.getBool(_keyTheme) ?? false;
    } else {
      final brightness = PlatformDispatcher.instance.platformBrightness;
      isDark = brightness == Brightness.dark;
    }
    final tintValue = prefs.getInt(_keyTint);
    final tintColor = tintValue != null ? Color(tintValue) : AppColors.primary;
    emit(state.copyWith(isDarkTheme: isDark, tintColor: tintColor));
  }

  Future<void> toggleTheme() async {
    final newValue = !state.isDarkTheme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTheme, newValue);
    emit(state.copyWith(isDarkTheme: newValue));
  }

  Future<void> setTintColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTint, color.value);
    emit(state.copyWith(tintColor: color));
  }
}

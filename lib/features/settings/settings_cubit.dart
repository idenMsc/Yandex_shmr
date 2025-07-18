import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/constants.dart';

class SettingsState {
  final bool isDarkTheme;
  final Color tintColor;
  final bool isHapticsEnabled;
  SettingsState({
    required this.isDarkTheme,
    required this.tintColor,
    required this.isHapticsEnabled,
  });

  SettingsState copyWith({
    bool? isDarkTheme,
    Color? tintColor,
    bool? isHapticsEnabled,
  }) =>
      SettingsState(
        isDarkTheme: isDarkTheme ?? this.isDarkTheme,
        tintColor: tintColor ?? this.tintColor,
        isHapticsEnabled: isHapticsEnabled ?? this.isHapticsEnabled,
      );
}

class SettingsCubit extends Cubit<SettingsState> {
  static const _keyTheme = 'isDarkTheme';
  static const _keyTint = 'tintColor';
  static const _keyHaptics = 'isHapticsEnabled';
  SettingsCubit()
      : super(SettingsState(
          isDarkTheme: false,
          tintColor: AppColors.primary,
          isHapticsEnabled: true,
        ));

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
    final isHaptics = prefs.getBool(_keyHaptics) ?? true;
    emit(state.copyWith(
      isDarkTheme: isDark,
      tintColor: tintColor,
      isHapticsEnabled: isHaptics,
    ));
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

  Future<void> toggleHaptics() async {
    final newValue = !state.isHapticsEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHaptics, newValue);
    emit(state.copyWith(isHapticsEnabled: newValue));
  }
}

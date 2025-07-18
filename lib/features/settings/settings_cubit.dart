import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final bool isDarkTheme;
  SettingsState({required this.isDarkTheme});

  SettingsState copyWith({bool? isDarkTheme}) =>
      SettingsState(isDarkTheme: isDarkTheme ?? this.isDarkTheme);
}

class SettingsCubit extends Cubit<SettingsState> {
  static const _key = 'isDarkTheme';
  SettingsCubit() : super(SettingsState(isDarkTheme: false));

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_key)) {
      final value = prefs.getBool(_key) ?? false;
      emit(state.copyWith(isDarkTheme: value));
    } else {
      // Если нет сохраненного значения, определяем системную тему
      final brightness = PlatformDispatcher.instance.platformBrightness;
      emit(state.copyWith(isDarkTheme: brightness == Brightness.dark));
    }
  }

  Future<void> toggleTheme() async {
    final newValue = !state.isDarkTheme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, newValue);
    emit(state.copyWith(isDarkTheme: newValue));
  }
}

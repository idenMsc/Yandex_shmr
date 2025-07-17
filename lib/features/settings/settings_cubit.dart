import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final bool useSystemTheme;
  SettingsState({required this.useSystemTheme});

  SettingsState copyWith({bool? useSystemTheme}) =>
      SettingsState(useSystemTheme: useSystemTheme ?? this.useSystemTheme);
}

class SettingsCubit extends Cubit<SettingsState> {
  static const _key = 'useSystemTheme';
  SettingsCubit() : super(SettingsState(useSystemTheme: true));

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_key) ?? true;
    emit(state.copyWith(useSystemTheme: value));
  }

  Future<void> toggleSystemTheme() async {
    final newValue = !state.useSystemTheme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, newValue);
    emit(state.copyWith(useSystemTheme: newValue));
  }
}

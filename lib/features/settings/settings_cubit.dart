import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsState {
  final bool isDarkTheme;
  SettingsState({required this.isDarkTheme});

  SettingsState copyWith({bool? isDarkTheme}) =>
      SettingsState(isDarkTheme: isDarkTheme ?? this.isDarkTheme);
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState(isDarkTheme: false));

  void toggleTheme() => emit(state.copyWith(isDarkTheme: !state.isDarkTheme));
}

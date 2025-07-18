import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageState {
  final Locale locale;
  LanguageState(this.locale);
}

class LanguageCubit extends Cubit<LanguageState> {
  static const _key = 'app_locale';
  LanguageCubit() : super(LanguageState(const Locale('ru')));

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key) ?? 'ru';
    emit(LanguageState(Locale(code)));
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
    emit(LanguageState(locale));
  }
}

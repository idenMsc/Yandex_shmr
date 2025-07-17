// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'SHMR Finance';

  @override
  String get navBarExpenses => 'Расходы';

  @override
  String get navBarIncome => 'Доходы';

  @override
  String get navBarAccount => 'Счет';

  @override
  String get navBarStats => 'Статьи';

  @override
  String get navBarSettings => 'Настройки';

  @override
  String get total => 'Итого';

  @override
  String get errorAccountNotFound =>
      'Извините, произошла ошибка, счет не найден';

  @override
  String get noTransactions => 'Информация о транзакциях недоступна';

  @override
  String get decimalSeparator => ',';

  @override
  String get settings => 'Настройки';

  @override
  String get darkTheme => 'Тёмная тема';

  @override
  String get mainColor => 'Основной цвет';

  @override
  String get sounds => 'Звуки';

  @override
  String get haptics => 'Хаптики';

  @override
  String get passwordCode => 'Код-пароль';

  @override
  String get sync => 'Синхронизация';

  @override
  String get language => 'Язык';

  @override
  String get about => 'О программе';
}

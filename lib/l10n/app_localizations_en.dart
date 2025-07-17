// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SHMR Finance';

  @override
  String get navBarExpenses => 'Expenses';

  @override
  String get navBarIncome => 'Income';

  @override
  String get navBarAccount => 'Account';

  @override
  String get navBarStats => 'Stats';

  @override
  String get navBarSettings => 'Settings';

  @override
  String get total => 'Total';

  @override
  String get errorAccountNotFound =>
      'Sorry, an error occurred, account not found';

  @override
  String get noTransactions => 'No transaction information available';

  @override
  String get decimalSeparator => '.';

  @override
  String get settings => 'Settings';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get mainColor => 'Main color';

  @override
  String get sounds => 'Sounds';

  @override
  String get haptics => 'Haptics';

  @override
  String get passwordCode => 'Password code';

  @override
  String get sync => 'Sync';

  @override
  String get language => 'Language';

  @override
  String get about => 'About';
}

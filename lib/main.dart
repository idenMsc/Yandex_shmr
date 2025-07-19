import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_25/features/expenses/presentation/screens/expenses_screen.dart';
import 'features/bank_accounts/presentation/bloc/wallet_bloc.dart';
import 'features/bank_accounts/presentation/bloc/operation_bloc.dart';
import 'features/categories/presentation/bloc/category_bloc.dart';
import 'features/transactions/presentation/bloc/transaction_bloc.dart';
import 'l10n/app_localizations.dart';
import 'injection_container.dart' as di;
import 'features/categories/data/datasources/category_remote_data_source.dart';
import 'features/transactions/data/account_remote_data_source.dart';
import 'package:worker_manager/worker_manager.dart';
import 'screens/splash_screen.dart';
import 'features/settings/settings_cubit.dart';
import 'dart:ui';
import 'features/settings/language_cubit.dart';
import 'features/settings/pin_code_screen.dart';
import 'features/settings/pin_code_service.dart';
import 'core/utils/widgets/app_with_lock.dart';
import 'core/utils/widgets/blur_guard.dart';
import 'core/config/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config().init();
  await workerManager.init(); // инициализация пула изолятов
  await di.init(); // Инициализация базы данных и DI
  // Прогреваем кэш категорий и счетов
  di.sl<CategoryRemoteDataSource>().getAllCategories().catchError((_) {});
  di.sl<AccountRemoteDataSource>().getAccounts().catchError((_) {});
  final settingsCubit = SettingsCubit();
  await settingsCubit.loadTheme();
  final languageCubit = LanguageCubit();
  await languageCubit.loadLocale();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: settingsCubit),
        BlocProvider.value(value: languageCubit),
      ],
      child: const FinanceApp(),
    ),
  );
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, langState) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<WalletBloc>(
              create: (context) => di.sl<WalletBloc>(),
            ),
            BlocProvider<OperationBloc>(
              create: (context) => di.sl<OperationBloc>(),
            ),
            BlocProvider<CategoryBloc>(
              create: (context) => di.sl<CategoryBloc>()..add(LoadCategories()),
            ),
            BlocProvider<TransactionBloc>(
              create: (context) => di.sl<TransactionBloc>(),
            ),
          ],
          child: _AppWithSplash(locale: langState.locale),
        );
      },
    );
  }
}

class _AppWithSplash extends StatefulWidget {
  final Locale locale;
  const _AppWithSplash({Key? key, required this.locale}) : super(key: key);

  @override
  State<_AppWithSplash> createState() => _AppWithSplashState();
}

class _AppWithSplashState extends State<_AppWithSplash> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final tint = state.tintColor;
        return MaterialApp(
          key: ValueKey(widget.locale.languageCode),
          title: 'SHMR Finance',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: tint,
            colorScheme: ColorScheme.light(
              primary: tint,
              secondary: tint,
              surface: Colors.white,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: tint,
              foregroundColor: Colors.white,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: tint,
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),
            scaffoldBackgroundColor: Colors.white,
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: tint,
              unselectedItemColor: Colors.grey,
            ),
            switchTheme: SwitchThemeData(
              thumbColor: MaterialStateProperty.all(tint),
              trackColor: MaterialStateProperty.all(tint.withOpacity(0.5)),
            ),
            iconTheme: IconThemeData(color: tint),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: tint),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(backgroundColor: tint),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: tint,
            colorScheme: ColorScheme.dark(
              primary: tint,
              secondary: tint,
              surface: const Color(0xFF121212),
              onPrimary: Colors.white,
              onSurface: Colors.white,
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: tint,
              foregroundColor: Colors.white,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: tint,
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: tint,
              unselectedItemColor: Colors.grey,
            ),
            switchTheme: SwitchThemeData(
              thumbColor: MaterialStateProperty.all(tint),
              trackColor: MaterialStateProperty.all(tint.withOpacity(0.5)),
            ),
            iconTheme: IconThemeData(color: tint),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: tint),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(backgroundColor: tint),
            ),
          ),
          themeMode: state.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          locale: widget.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ru'),
          ],
          home: BlurGuard(
            child: AppWithLock(
              child:
                  _showSplash ? const SplashScreen() : const ExpensesScreen(),
            ),
          ),
        );
      },
    );
  }
}

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await workerManager.init(); // инициализация пула изолятов
  await di.init(); // Инициализация базы данных и DI
  // Прогреваем кэш категорий и счетов
  di.sl<CategoryRemoteDataSource>().getAllCategories().catchError((_) {});
  di.sl<AccountRemoteDataSource>().getAccounts().catchError((_) {});
  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: const _AppWithSplash(),
    );
  }
}

class _AppWithSplash extends StatefulWidget {
  const _AppWithSplash({Key? key}) : super(key: key);

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
    return MaterialApp(
      title: 'SHMR Finance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
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
      home: _showSplash ? const SplashScreen() : const ExpensesScreen(),
    );
  }
}

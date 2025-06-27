import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/expenses_screen.dart' hide ExpensesScreen;
import 'features/transactions/transaction_bloc.dart';
import 'features/transactions/transaction_event.dart';
import 'features/transactions/transaction_state.dart';
import 'features/transactions/data/transaction_repository_impl.dart';
import 'features/transactions/data/mock_transaction_remote_data_source.dart';
import 'features/transactions/data/mock_account_remote_data_source.dart';
import 'main.dart';

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final accountRemoteDataSource = MockAccountRemoteDataSource();
    final transactionRemoteDataSource = MockTransactionRemoteDataSource();
    final transactionRepository = TransactionRepositoryImpl(
        remoteDataSource: transactionRemoteDataSource);

    return MultiBlocProvider(
      providers: [
        BlocProvider<TransactionBloc>(
          create: (context) => TransactionBloc(
            transactionRepository: transactionRepository,
            accountRemoteDataSource: accountRemoteDataSource,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'SHMR Finance',
        theme: ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const ExpensesScreen(),
      ),
    );
  }
}

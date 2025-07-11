import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shmr_25/features/categories/data/datasources/category_local_data_source.dart';
import 'package:shmr_25/features/categories/data/datasources/category_local_data_source_impl.dart';
import 'package:shmr_25/features/categories/data/repositories/category_repository_impl.dart';
import 'package:shmr_25/features/categories/domain/repositories/category_repository.dart';
import 'package:shmr_25/features/categories/domain/usecases/get_all_categories.dart';
import 'package:shmr_25/features/categories/presentation/bloc/category_bloc.dart';
import 'package:shmr_25/core/data/database_service.dart';
import 'package:shmr_25/core/data/repositories/wallet_repository.dart';
import 'package:shmr_25/core/data/repositories/operation_repository.dart';
import 'package:shmr_25/features/bank_accounts/presentation/bloc/wallet_bloc.dart';
import 'package:shmr_25/features/bank_accounts/presentation/bloc/operation_bloc.dart';
import 'package:shmr_25/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:shmr_25/core/network_client.dart';
import 'package:shmr_25/core/network_service.dart';
import 'package:shmr_25/core/data/sync_service.dart';
import 'package:shmr_25/core/data/backup_repository.dart';
import 'package:shmr_25/core/connection_watcher.dart';
import 'package:shmr_25/features/transactions/data/transaction_remote_data_source.dart';
import 'package:shmr_25/features/transactions/data/account_remote_data_source.dart';
import 'package:shmr_25/features/transactions/data/transaction_repository_impl.dart';
import 'package:shmr_25/features/transactions/transaction_bloc.dart';
import 'features/transactions/domain/services/transaction_chart_service.dart';
import 'core/error/global_ui_bloc.dart';
import 'core/network/connection_status_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Network
  sl.registerLazySingleton(() => NetworkClient());
  sl.registerLazySingleton(() => NetworkService(sl()));

  // Backup and Sync services
  sl.registerLazySingleton(() => BackupRepository());

  // Connection watcher
  sl.registerLazySingleton(() => ConnectionWatcher(
        onOnline: () {
          // Автосинхронизация при восстановлении соединения
          sl<SyncService>().syncPendingOperations();
        },
      ));

  // Data sources
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSource(networkService: sl()),
  );
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSource(networkService: sl()),
  );
  sl.registerLazySingleton<AccountRemoteDataSource>(
    () => AccountRemoteDataSource(networkService: sl()),
  );

  // SyncService
  sl.registerLazySingleton(() => SyncService(
        sl<NetworkClient>().dio,
        sl<BackupRepository>(),
      ));

  // Repository
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<TransactionRepositoryImpl>(
    () => TransactionRepositoryImpl(
      remoteDataSource: sl(),
      syncService: sl(),
      backupRepository: sl(),
      connectionWatcher: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => GetAllCategories(sl()));

  // Bloc
  sl.registerFactory(() => CategoryBloc(getAllCategories: sl()));
  sl.registerFactory(() => TransactionBloc(
        transactionRepository: sl(),
        accountRemoteDataSource: sl(),
      ));

  // Database
  final databaseService = await DatabaseService.getInstance();
  sl.registerSingleton<DatabaseService>(databaseService);
  sl.registerSingleton<WalletRepository>(databaseService.walletRepository);
  sl.registerSingleton<OperationRepository>(
      databaseService.operationRepository);

  // BLoC для базы данных
  sl.registerFactory(() => WalletBloc(sl()));
  sl.registerFactory(() => OperationBloc(sl()));

  sl.registerFactory<TransactionChartService>(() => TransactionChartService(
        transactionRepository: sl<TransactionRepositoryImpl>(),
        accountRemoteDataSource: sl<AccountRemoteDataSource>(),
      ));

  sl.registerLazySingleton<GlobalUiBloc>(() => GlobalUiBloc());
  sl.registerLazySingleton<ConnectionStatusBloc>(() => ConnectionStatusBloc());
}

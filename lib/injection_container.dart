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

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Bloc

  sl.registerFactory(
    () => CategoryBloc(getAllCategories: sl()),
  );

  // UseCases

  sl.registerLazySingleton(() => GetAllCategories(sl()));

  // Repository

  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(localDataSource: sl()),
  );

  // Data sources

  sl.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Database
  final databaseService = await DatabaseService.getInstance();
  sl.registerSingleton<DatabaseService>(databaseService);
  sl.registerSingleton<WalletRepository>(databaseService.walletRepository);
  sl.registerSingleton<OperationRepository>(
      databaseService.operationRepository);

  // BLoC для базы данных
  sl.registerFactory(() => WalletBloc(sl()));
  sl.registerFactory(() => OperationBloc(sl()));
}

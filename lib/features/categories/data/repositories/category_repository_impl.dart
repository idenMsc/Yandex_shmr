import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Category>>> getAllCategories() async {
    try {
      final categories = await localDataSource.getAllCategories();
      return Right(categories);
    } catch (e) {
      return Left(CacheFailure('Failed to get categories from cache'));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getIncomeCategories() async {
    try {
      final categories = await localDataSource.getIncomeCategories();
      return Right(categories);
    } catch (e) {
      return Left(CacheFailure('Failed to get income categories from cache'));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getExpenseCategories() async {
    try {
      final categories = await localDataSource.getExpenseCategories();
      return Right(categories);
    } catch (e) {
      return Left(CacheFailure('Failed to get expense categories from cache'));
    }
  }
}

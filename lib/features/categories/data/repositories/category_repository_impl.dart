import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Category>>> getAllCategories() async {
    try {
      final categories = await remoteDataSource.getAllCategories();
      return Right(categories);
    } catch (e) {
      return const Left(ServerFailure('Failed to get categories from API'));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getIncomeCategories() async {
    try {
      final categories = await remoteDataSource.getAllCategories();
      return Right(categories.where((c) => c.isIncome).toList());
    } catch (e) {
      return const Left(
          ServerFailure('Failed to get income categories from API'));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getExpenseCategories() async {
    try {
      final categories = await remoteDataSource.getAllCategories();
      return Right(categories.where((c) => !c.isIncome).toList());
    } catch (e) {
      return const Left(
          ServerFailure('Failed to get expense categories from API'));
    }
  }
}

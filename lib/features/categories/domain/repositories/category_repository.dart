import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/category.dart';

abstract class CategoryRepository {
  FutureEither<List<Category>> getAllCategories();
  FutureEither<List<Category>> getIncomeCategories();
  FutureEither<List<Category>> getExpenseCategories();
}
import '../../domain/entities/category.dart';

abstract class CategoryLocalDataSource {
  Future<List<Category>> getAllCategories();
  Future<List<Category>> getIncomeCategories();
  Future<List<Category>> getExpenseCategories();
}

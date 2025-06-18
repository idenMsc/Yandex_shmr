import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/category.dart';
import 'category_local_data_source.dart';

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final SharedPreferences sharedPreferences;

  CategoryLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<Category>> getAllCategories() async {
    // TODO: Implement getting all categories from SharedPreferences
    return [];
  }

  @override
  Future<List<Category>> getIncomeCategories() async {
    // TODO: Implement getting income categories from SharedPreferences
    return [];
  }

  @override
  Future<List<Category>> getExpenseCategories() async {
    // TODO: Implement getting expense categories from SharedPreferences
    return [];
  }
}

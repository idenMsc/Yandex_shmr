import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/category.dart';
import 'category_local_data_source.dart';

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final SharedPreferences sharedPreferences;

  CategoryLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<Category>> getAllCategories() async {
    return [
      Category(id: 1, name: 'Зарплата', emoji: '💰', isIncome: true),
      Category(id: 2, name: 'Аренда квартиры', emoji: '🛕', isIncome: false),
      Category(id: 3, name: 'Одежда', emoji: '👗', isIncome: false),
      Category(id: 4, name: 'На собачку', emoji: '🐶', isIncome: false),
      Category(id: 5, name: 'Ремонт квартиры', emoji: 'РК', isIncome: false),
      Category(id: 6, name: 'Продукты', emoji: '🎈', isIncome: false),
      Category(id: 7, name: 'Спортзал', emoji: '🏋️‍♀️', isIncome: false),
      Category(id: 8, name: 'Медицина', emoji: '💉', isIncome: false),
      Category(id: 9, name: 'Премия', emoji: '🍀', isIncome: true),
    ];
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

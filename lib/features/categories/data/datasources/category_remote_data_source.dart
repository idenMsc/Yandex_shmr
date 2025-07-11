import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network_service.dart';
import '../models/category_model.dart';
import '../../domain/entities/category.dart';

class CategoryRemoteDataSource {
  final NetworkService networkService;
  CategoryRemoteDataSource({required this.networkService});

  Future<List<Category>> getAllCategories() async {
    try {
      final data = await networkService.get<List<dynamic>>('/categories');
      final categories =
          data.map((json) => CategoryModel.fromJson(json).toEntity()).toList();
      await _saveToCache(categories);
      return categories;
    } catch (e) {
      print(
          'CategoryRemoteDataSource.getAllCategories: ошибка сети, пробуем из кэша ($e)');
      final cached = await _loadFromCache();
      if (cached.isNotEmpty) {
        print(
            'CategoryRemoteDataSource.getAllCategories: возвращаем категории из кэша (${cached.length})');
        return cached;
      } else {
        print('CategoryRemoteDataSource.getAllCategories: кэш пустой, rethrow');
        rethrow;
      }
    }
  }

  Future<void> _saveToCache(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList =
        categories.map((c) => jsonEncode(_categoryToJson(c))).toList();
    await prefs.setStringList('categories_cache', jsonList);
  }

  Future<List<Category>> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('categories_cache') ?? [];
    return jsonList.map((j) => _categoryFromJson(jsonDecode(j))).toList();
  }

  Map<String, dynamic> _categoryToJson(Category c) => {
        'id': c.id,
        'name': c.name,
        'emoji': c.emoji,
        'isIncome': c.isIncome,
      };

  Category _categoryFromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'],
        emoji: json['emoji'],
        isIncome: json['isIncome'],
      );
}

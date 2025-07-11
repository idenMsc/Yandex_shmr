import '../../../../core/network_service.dart';
import '../models/category_model.dart';
import '../../domain/entities/category.dart';

class CategoryRemoteDataSource {
  final NetworkService networkService;
  CategoryRemoteDataSource({required this.networkService});

  Future<List<Category>> getAllCategories() async {
    final data = await networkService.get<List<dynamic>>('/categories');
    return data.map((json) => CategoryModel.fromJson(json).toEntity()).toList();
  }
}

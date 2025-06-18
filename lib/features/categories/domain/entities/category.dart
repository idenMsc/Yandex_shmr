import 'package:equatable/equatable.dart';
import '../../data/models/category_model.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String emoji;
  final bool isIncome;

  const Category({
    required this.id,
    required this.name,
    required this.emoji,
    required this.isIncome,
  });

  factory Category.fromModel(CategoryModel model) {
    return Category(
      id: model.id,
      name: model.name,
      emoji: model.emoji,
      isIncome: model.isIncome,
    );
  }

  @override
  List<Object> get props => [id, name, emoji, isIncome];
}

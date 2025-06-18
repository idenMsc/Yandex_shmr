import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import 'package:shmr_25/core/usecases/usecase.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetAllCategories extends UseCase<List<Category>, NoParams> {
  final CategoryRepository repository;

  GetAllCategories(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) async {
    return await repository.getAllCategories();
  }
}

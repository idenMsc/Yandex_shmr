import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shmr_25/core/error/failures.dart';
import 'package:shmr_25/core/usecases/usecase.dart';
import 'package:shmr_25/features/categories/domain/entities/category.dart';
import 'package:shmr_25/features/categories/domain/usecases/get_all_categories.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategories getAllCategories;

  CategoryBloc({required this.getAllCategories}) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    final Either<Failure, List<Category>> result =
        await getAllCategories(NoParams());
    result.fold(
      (failure) => emit(CategoryError(message: _mapFailureToMessage(failure))),
      (categories) => emit(CategoryLoaded(categories: categories)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return "Server_Error";
      case CacheFailure:
        return "Cache error";
      default:
        return "Unexpected error";
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shmr_25/core/error/failures.dart';
import 'package:shmr_25/core/usecases/usecase.dart';
import 'package:shmr_25/features/categories/domain/entities/category.dart';
import 'package:shmr_25/features/categories/domain/usecases/get_all_categories.dart';
import '../../../../core/error/global_ui_bloc.dart';
import '../../../../injection_container.dart';

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
    sl<GlobalUiBloc>().add(ShowLoading());
    emit(CategoryLoading());
    final result = await getAllCategories(NoParams());
    result.fold(
      (failure) {
        sl<GlobalUiBloc>().add(ShowError(_mapFailureToMessage(failure)));
        emit(CategoryError(message: _mapFailureToMessage(failure)));
      },
      (categories) => emit(CategoryLoaded(categories: categories)),
    );
    sl<GlobalUiBloc>().add(HideLoading());
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return "Server_Error";
      case CacheFailure _:
        return "Cache error";
      default:
        return "Unexpected error";
    }
  }
}

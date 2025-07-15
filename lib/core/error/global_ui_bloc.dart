import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';

class GlobalUiState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  const GlobalUiState({this.isLoading = false, this.errorMessage});

  GlobalUiState copyWith({bool? isLoading, String? errorMessage}) {
    return GlobalUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage];
}

abstract class GlobalUiEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShowLoading extends GlobalUiEvent {}

class HideLoading extends GlobalUiEvent {}

class ShowError extends GlobalUiEvent {
  final String message;
  ShowError(this.message);
  @override
  List<Object?> get props => [message];
}

class ClearError extends GlobalUiEvent {}

class GlobalUiBloc extends Bloc<GlobalUiEvent, GlobalUiState> {
  Timer? _loadingTimer;

  GlobalUiBloc() : super(const GlobalUiState()) {
    on<ShowLoading>((event, emit) async {
      _loadingTimer?.cancel();
      emit(state.copyWith(isLoading: true));
    });

    on<HideLoading>((event, emit) async {
      _loadingTimer?.cancel();
      _loadingTimer = Timer(const Duration(milliseconds: 500), () {
        if (!emit.isDone) emit(state.copyWith(isLoading: false));
      });
    });

    on<ShowError>((event, emit) async {
      _loadingTimer?.cancel();
      emit(state.copyWith(errorMessage: event.message, isLoading: false));
    });

    on<ClearError>((event, emit) async {
      emit(state.copyWith(errorMessage: null));
    });
  }

  @override
  Future<void> close() {
    _loadingTimer?.cancel();
    return super.close();
  }
}

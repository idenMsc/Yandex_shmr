import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/data/database.dart';
import '../../../../core/data/repositories/operation_repository.dart';

// События
abstract class OperationEvent extends Equatable {
  const OperationEvent();

  @override
  List<Object?> get props => [];
}

class LoadOperations extends OperationEvent {}

class LoadOperationsByWallet extends OperationEvent {
  final int walletId;

  const LoadOperationsByWallet(this.walletId);

  @override
  List<Object?> get props => [walletId];
}

class LoadOperationsByDateRange extends OperationEvent {
  final DateTime start;
  final DateTime end;

  const LoadOperationsByDateRange(this.start, this.end);

  @override
  List<Object?> get props => [start, end];
}

class CreateOperation extends OperationEvent {
  final OperationTableCompanion operation;

  const CreateOperation(this.operation);

  @override
  List<Object?> get props => [operation];
}

class DeleteOperation extends OperationEvent {
  final int operationId;

  const DeleteOperation(this.operationId);

  @override
  List<Object?> get props => [operationId];
}

class UpdateOperation extends OperationEvent {
  final OperationTableCompanion operation;

  const UpdateOperation(this.operation);

  @override
  List<Object?> get props => [operation];
}

// Внутренние события для обновления UI
class _OperationsUpdated extends OperationEvent {
  final List<OperationDbModel> operations;

  const _OperationsUpdated(this.operations);

  @override
  List<Object?> get props => [operations];
}

// Состояния
abstract class OperationState extends Equatable {
  const OperationState();

  @override
  List<Object?> get props => [];
}

class OperationInitial extends OperationState {}

class OperationsLoading extends OperationState {}

class OperationsLoaded extends OperationState {
  final List<OperationDbModel> operations;

  const OperationsLoaded(this.operations);

  @override
  List<Object?> get props => [operations];
}

class OperationsError extends OperationState {
  final String message;

  const OperationsError(this.message);

  @override
  List<Object?> get props => [message];
}

class OperationCreating extends OperationState {}

class OperationCreated extends OperationState {}

class OperationDeleting extends OperationState {}

class OperationDeleted extends OperationState {}

// BLoC
class OperationBloc extends Bloc<OperationEvent, OperationState> {
  final OperationRepository repository;
  StreamSubscription<List<OperationDbModel>>? _operationsSubscription;

  OperationBloc(this.repository) : super(OperationInitial()) {
    on<LoadOperations>(_onLoadOperations);
    on<LoadOperationsByWallet>(_onLoadOperationsByWallet);
    on<LoadOperationsByDateRange>(_onLoadOperationsByDateRange);
    on<CreateOperation>(_onCreateOperation);
    on<DeleteOperation>(_onDeleteOperation);
    on<UpdateOperation>(_onUpdateOperation);
    on<_OperationsUpdated>(_onOperationsUpdated);
  }

  Future<void> _onLoadOperations(
      LoadOperations event, Emitter<OperationState> emit) async {
    emit(OperationsLoading());

    await _operationsSubscription?.cancel();
    _operationsSubscription = repository.getAllOperations().listen(
          (operations) => add(_OperationsUpdated(operations)),
          onError: (error) => emit(OperationsError(error.toString())),
        );
  }

  Future<void> _onLoadOperationsByWallet(
      LoadOperationsByWallet event, Emitter<OperationState> emit) async {
    emit(OperationsLoading());

    await _operationsSubscription?.cancel();
    _operationsSubscription =
        repository.getOperationsByWallet(event.walletId).listen(
              (operations) => add(_OperationsUpdated(operations)),
              onError: (error) => emit(OperationsError(error.toString())),
            );
  }

  Future<void> _onLoadOperationsByDateRange(
      LoadOperationsByDateRange event, Emitter<OperationState> emit) async {
    emit(OperationsLoading());

    await _operationsSubscription?.cancel();
    _operationsSubscription =
        repository.getOperationsByDateRange(event.start, event.end).listen(
              (operations) => add(_OperationsUpdated(operations)),
              onError: (error) => emit(OperationsError(error.toString())),
            );
  }

  Future<void> _onCreateOperation(
      CreateOperation event, Emitter<OperationState> emit) async {
    emit(OperationCreating());

    try {
      final result = await repository.createOperation(event.operation);
      if (result > 0) {
        // emit(OperationCreated()); // Убираем это состояние
        // Не сбрасываем подписку, стрим сам обновит состояние
      } else {
        emit(const OperationsError('Не удалось создать операцию'));
      }
    } catch (e) {
      emit(OperationsError(e.toString()));
    }
  }

  Future<void> _onDeleteOperation(
      DeleteOperation event, Emitter<OperationState> emit) async {
    emit(OperationDeleting());

    try {
      final result = await repository.deleteOperation(event.operationId);
      if (result > 0) {
        emit(OperationDeleted());
      } else {
        emit(const OperationsError('Не удалось удалить операцию'));
      }
    } catch (e) {
      emit(OperationsError(e.toString()));
    }
  }

  Future<void> _onUpdateOperation(
      UpdateOperation event, Emitter<OperationState> emit) async {
    emit(OperationCreating());
    try {
      final result = await repository.updateOperation(event.operation);
      if (result) {
        // emit(OperationCreated()); // Не сбрасываем подписку, стрим сам обновит состояние
      } else {
        emit(const OperationsError('Не удалось обновить операцию'));
      }
    } catch (e) {
      emit(OperationsError(e.toString()));
    }
  }

  void _onOperationsUpdated(
      _OperationsUpdated event, Emitter<OperationState> emit) {
    emit(OperationsLoaded(event.operations));
  }

  @override
  Future<void> close() {
    _operationsSubscription?.cancel();
    return super.close();
  }
}

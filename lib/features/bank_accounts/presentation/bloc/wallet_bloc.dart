import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/data/database.dart';
import '../../../../core/data/repositories/wallet_repository.dart';

// События
abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class LoadWallets extends WalletEvent {}

class UpdateWalletName extends WalletEvent {
  final int walletId;
  final String newName;

  const UpdateWalletName(this.walletId, this.newName);

  @override
  List<Object?> get props => [walletId, newName];
}

class UpdateWalletBalance extends WalletEvent {
  final int walletId;
  final String newBalance;

  const UpdateWalletBalance(this.walletId, this.newBalance);

  @override
  List<Object?> get props => [walletId, newBalance];
}

class UpdateWalletCurrency extends WalletEvent {
  final int walletId;
  final String newCurrency;

  const UpdateWalletCurrency(this.walletId, this.newCurrency);

  @override
  List<Object?> get props => [walletId, newCurrency];
}

// Внутренние события для обновления UI
class _WalletsUpdated extends WalletEvent {
  final List<WalletDbModel> wallets;

  const _WalletsUpdated(this.wallets);

  @override
  List<Object?> get props => [wallets];
}

// Состояния
abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletsLoading extends WalletState {}

class WalletsLoaded extends WalletState {
  final List<WalletDbModel> wallets;

  const WalletsLoaded(this.wallets);

  @override
  List<Object?> get props => [wallets];
}

class WalletsError extends WalletState {
  final String message;

  const WalletsError(this.message);

  @override
  List<Object?> get props => [message];
}

class WalletUpdating extends WalletState {}

class WalletUpdated extends WalletState {}

// BLoC
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository repository;
  StreamSubscription<List<WalletDbModel>>? _walletsSubscription;

  WalletBloc(this.repository) : super(WalletInitial()) {
    on<LoadWallets>(_onLoadWallets);
    on<UpdateWalletName>(_onUpdateWalletName);
    on<UpdateWalletBalance>(_onUpdateWalletBalance);
    on<UpdateWalletCurrency>(_onUpdateWalletCurrency);
    on<_WalletsUpdated>(_onWalletsUpdated);
  }

  Future<void> _onLoadWallets(
      LoadWallets event, Emitter<WalletState> emit) async {
    emit(WalletsLoading());

    await _walletsSubscription?.cancel();
    _walletsSubscription = repository.getAllWallets().listen(
          (wallets) => add(_WalletsUpdated(wallets)),
          onError: (error) => emit(WalletsError(error.toString())),
        );
  }

  Future<void> _onUpdateWalletName(
      UpdateWalletName event, Emitter<WalletState> emit) async {
    emit(WalletUpdating());

    try {
      final result = await repository.updateName(event.walletId, event.newName);
      if (result > 0) {
        emit(WalletUpdated());
      } else {
        emit(const WalletsError('Не удалось обновить название кошелька'));
      }
    } catch (e) {
      emit(WalletsError(e.toString()));
    }
  }

  Future<void> _onUpdateWalletBalance(
      UpdateWalletBalance event, Emitter<WalletState> emit) async {
    emit(WalletUpdating());

    try {
      final result =
          await repository.updateBalance(event.walletId, event.newBalance);
      if (result > 0) {
        emit(WalletUpdated());
      } else {
        emit(const WalletsError('Не удалось обновить баланс'));
      }
    } catch (e) {
      emit(WalletsError(e.toString()));
    }
  }

  Future<void> _onUpdateWalletCurrency(
      UpdateWalletCurrency event, Emitter<WalletState> emit) async {
    emit(WalletUpdating());

    try {
      final result =
          await repository.updateCurrency(event.walletId, event.newCurrency);
      if (result > 0) {
        emit(WalletUpdated());
      } else {
        emit(const WalletsError('Не удалось обновить валюту'));
      }
    } catch (e) {
      emit(WalletsError(e.toString()));
    }
  }

  void _onWalletsUpdated(_WalletsUpdated event, Emitter<WalletState> emit) {
    emit(WalletsLoaded(event.wallets));
  }

  @override
  Future<void> close() {
    _walletsSubscription?.cancel();
    return super.close();
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:async';

enum NetworkConnectionStatus { online, offline }

class ConnectionStatusState extends Equatable {
  final NetworkConnectionStatus status;
  final bool isOfflineMode;

  const ConnectionStatusState({
    this.status = NetworkConnectionStatus.online,
    this.isOfflineMode = false,
  });

  ConnectionStatusState copyWith({
    NetworkConnectionStatus? status,
    bool? isOfflineMode,
  }) {
    return ConnectionStatusState(
      status: status ?? this.status,
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
    );
  }

  @override
  List<Object?> get props => [status, isOfflineMode];
}

abstract class ConnectionStatusEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckConnectionStatus extends ConnectionStatusEvent {}

class SetOfflineMode extends ConnectionStatusEvent {
  final bool isOffline;
  SetOfflineMode(this.isOffline);

  @override
  List<Object?> get props => [isOffline];
}

class ConnectionStatusBloc
    extends Bloc<ConnectionStatusEvent, ConnectionStatusState> {
  final InternetConnectionChecker _connectionChecker;
  StreamSubscription<InternetConnectionStatus>? _connectionSubscription;

  ConnectionStatusBloc({InternetConnectionChecker? connectionChecker})
      : _connectionChecker = connectionChecker ?? InternetConnectionChecker(),
        super(const ConnectionStatusState()) {
    on<CheckConnectionStatus>(_onCheckConnectionStatus);
    on<SetOfflineMode>((event, emit) async {
      emit(state.copyWith(isOfflineMode: event.isOffline));
    });

    // Начинаем мониторинг соединения
    _startConnectionMonitoring();
  }

  void _startConnectionMonitoring() {
    _connectionSubscription = _connectionChecker.onStatusChange.listen(
      (status) {
        final isOnline = status == InternetConnectionStatus.connected;
        emit(state.copyWith(
          status: isOnline
              ? NetworkConnectionStatus.online
              : NetworkConnectionStatus.offline,
        ));
      },
    );
  }

  Future<void> _onCheckConnectionStatus(
    CheckConnectionStatus event,
    Emitter<ConnectionStatusState> emit,
  ) async {
    final result = await _connectionChecker.connectionStatus;
    final isOnline = result == InternetConnectionStatus.connected;
    emit(state.copyWith(
      status: isOnline
          ? NetworkConnectionStatus.online
          : NetworkConnectionStatus.offline,
    ));
  }

  void _onSetOfflineMode(
    SetOfflineMode event,
    Emitter<ConnectionStatusState> emit,
  ) {
    emit(state.copyWith(isOfflineMode: event.isOffline));
  }

  @override
  Future<void> close() {
    _connectionSubscription?.cancel();
    return super.close();
  }
}

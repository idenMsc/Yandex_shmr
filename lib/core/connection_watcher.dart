import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Статус сети
enum ConnectionStatus { online, offline }

/// Сервис отслеживания статуса соединения и автосинхронизации
class ConnectionWatcher {
  final void Function() onOnline;
  late final StreamSubscription _subscription;
  late final InternetConnectionChecker _checker;
  ConnectionStatus _status = ConnectionStatus.online;

  ConnectionWatcher({required this.onOnline}) {
    _checker = InternetConnectionChecker.createInstance();
    _checker.hasConnection.then((hasConnection) {
      _status =
          hasConnection ? ConnectionStatus.online : ConnectionStatus.offline;
    });
    _subscription = _checker.onStatusChange.listen((status) async {
      if (status == InternetConnectionStatus.connected) {
        _status = ConnectionStatus.online;
        onOnline();
      } else {
        _status = ConnectionStatus.offline;
      }
    });
  }

  ConnectionStatus get status => _status;

  void dispose() {
    _subscription.cancel();
  }
}

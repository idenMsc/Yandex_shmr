import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinCodeService {
  static const _pinKey = 'user_pin_code';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> setPin(String pin) async {
    if (pin.length != 4 || int.tryParse(pin) == null) {
      throw ArgumentError('PIN must be a 4-digit number');
    }
    await _storage.write(key: _pinKey, value: pin);
  }

  Future<String?> getPin() async {
    return await _storage.read(key: _pinKey);
  }

  Future<bool> checkPin(String pin) async {
    final storedPin = await getPin();
    return storedPin == pin;
  }

  Future<void> deletePin() async {
    await _storage.delete(key: _pinKey);
  }

  Future<bool> hasPin() async {
    final pin = await getPin();
    return pin != null && pin.length == 4;
  }
}

class BiometricService {
  Future<bool> isBiometricAvailable() async => false;
  Future<bool> isBiometricEnabled() async => false;
  Future<void> setBiometricEnabled(bool enabled) async {}
  Future<bool> authenticate() async => false;
}

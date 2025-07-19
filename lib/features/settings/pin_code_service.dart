import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

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
  static const _biometricKey = 'biometric_enabled';
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> isBiometricAvailable() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      // Временно для тестирования на эмуляторе
      return true; // canCheck && isSupported;
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      final result = await _auth.authenticate(
        localizedReason: 'Пожалуйста, подтвердите личность',
        options:
            const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: _biometricKey, value: enabled ? '1' : '0');
  }

  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _biometricKey);
    return value == '1';
  }
}

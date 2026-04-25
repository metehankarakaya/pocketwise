import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityProvider extends Notifier<bool> {
  @override
  bool build() {
    _loadLockStatus();
    return false;
  }

  final _storage = const FlutterSecureStorage();

  void _loadLockStatus() async {
    final pin = await _storage.read(key: "user_pin");
    state = pin != null;
  }

  void enableLock(String pin) async {
    await _storage.write(key: "user_pin", value: pin);
    state = true;
  }

  void disableLock() async {
    await _storage.delete(key: "user_pin");
    state = false;
  }

  Future<bool> verifyPin(String pin) async {
    final savedPin = await _storage.read(key: "user_pin");
    return pin == savedPin;
  }

}

final securityProvider = NotifierProvider<SecurityProvider, bool>(SecurityProvider.new);

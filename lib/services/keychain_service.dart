import 'package:flutter_keychain/flutter_keychain.dart';

import '../util/logger.dart';

class KeychainService {
  static KeychainService? _instance;
  static KeychainService get instance => _instance!;

  KeychainService._();

  factory KeychainService() {
    if (_instance != null) {
      throw StateError('LocalStorageService already created');
    }

    _instance = KeychainService._();
    return _instance!;
  }

  static const String _key = 'refreshToken';
  Future<String?> readRefreshToken() async {
    return await FlutterKeychain.get(key: _key);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await FlutterKeychain.put(key: _key, value: refreshToken);
    Logger.instance.info(
      'KeychainService.saveRefreshToken',
      'token saved',
    );
  }

  Future<void> removeRefreshToken() async {
    await FlutterKeychain.remove(key: _key);
  }

  Future<void> clearKeychain() async {
    await FlutterKeychain.clear();
  }
}

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

import '../util/logger.dart';

class ConnectivityService {
  static ConnectivityService? _instance;
  static ConnectivityService get instance => _instance!;

  const ConnectivityService._();

  factory ConnectivityService() {
    if (_instance != null) {
      throw StateError('Connectivity service already created!');
    }

    _instance = const ConnectivityService._();
    return _instance!;
  }

  Future<bool> isConnected() async {
    ConnectivityResult result;

    try {
      final Connectivity _connectivity = Connectivity();
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      Logger.instance.info('Connectivity.chechConnectivity', e.message);
      return false;
    }

    if (result != ConnectivityResult.mobile &&
        result != ConnectivityResult.wifi &&
        result != ConnectivityResult.ethernet) {
      Logger.instance
          .info('ConnectivityResult', 'device not connected to any network');
      return false;
    }

    return true;
  }
}

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

/*class ConnectivityService {
  final Connectivity connectivity;

  ConnectivityService(this.connectivity);

  Stream<bool> get connectionStream async* {
    // 🔥 Emit initial state FIRST
    final initial = await connectivity.checkConnectivity();
    yield initial != ConnectivityResult.none;

    // 🔥 Then listen for changes
    await for (final result in connectivity.onConnectivityChanged) {
      yield result != ConnectivityResult.none;
    }
  }

  Future<bool> isOnline() async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}*/

class ConnectivityService {
  final Connectivity connectivity;

  ConnectivityService(this.connectivity);

  Stream<bool> get connectionStream async* {
    await for (final result in connectivity.onConnectivityChanged) {
      final hasInternet = await _hasInternet();
      yield hasInternet;
    }
  }

  Future<bool> isOnline() async {
    return _hasInternet();
  }

  Future<bool> _hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}

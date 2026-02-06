import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

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

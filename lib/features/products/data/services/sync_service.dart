import 'dart:async';
import '../../../../core/network/connectivity_service.dart';
import '../../domain/usecases/sync_product.dart';

class SyncService {
  final ConnectivityService connectivityService;
  final SyncProducts syncProducts;

  StreamSubscription? _subscription;

  SyncService(this.connectivityService, this.syncProducts);

  void start() {
    _subscription = connectivityService.connectionStream.listen((isOnline) {
      if (isOnline) {
        syncProducts(); // Trigger background sync
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}

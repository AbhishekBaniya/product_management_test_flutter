import 'package:flutter/material.dart';

import '../../../../core/network/connectivity_service.dart';
import '../../../../injection_container.dart';
/*

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivity = sl<ConnectivityService>();

    return StreamBuilder<bool>(
      stream: connectivity.connectionStream,
      builder: (context, snapshot) {
        final isOnline = snapshot.data ?? true;
        if (isOnline) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          color: Colors.red,
          padding: const EdgeInsets.all(8),
          child: const Text(
            'You are offline',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}
*/
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivity = sl<ConnectivityService>();

    return StreamBuilder<bool>(
      stream: connectivity.connectionStream,
      initialData: true, // 👈 important fallback
      builder: (context, snapshot) {
        final isOnline = snapshot.data ?? true;

        if (isOnline) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          color: Colors.red,
          padding: const EdgeInsets.all(8),
          child: const Text(
            'You are offline',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}

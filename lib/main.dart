import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/products/data/services/sync_service.dart';

import 'features/products/presentation/pages/product_list_page.dart';
import 'injection_container.dart' as di;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await di.init(); // Dependency injection

  // Start background sync listener
  di.sl<SyncService>().start();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Merchant Products',
      home: ProductListPage(),
    );
  }
}
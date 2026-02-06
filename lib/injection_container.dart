import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'core/network/connectivity_service.dart';
import 'core/network/dio_client.dart';
import 'features/products/data/datasources/product_local_datasource.dart';
import 'features/products/data/datasources/product_remote_datasource.dart';
import 'features/products/data/models/product_model.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/data/services/sync_service.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/domain/usecases/create_product.dart';
import 'features/products/domain/usecases/get_product_detail.dart';
import 'features/products/domain/usecases/get_products.dart';
import 'features/products/domain/usecases/sync_product.dart';
import 'features/products/domain/usecases/update_product.dart';
import 'features/products/presentation/controllers/product_detail_controller.dart';
import 'features/products/presentation/controllers/product_form_controller.dart';
import 'features/products/presentation/controllers/product_list_controller.dart';
import 'package:get_it/get_it.dart';


final sl = GetIt.instance;
Future<void> init() async {

  /// EXTERNAL (FIRST)
  /// // ✅ DO THIS
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  //final box = await Hive.openBox<ProductModel>('products_box');

  //sl.registerLazySingleton(() => box);

  /// REGISTER ADAPTER FIRST
  Hive.registerAdapter(ProductModelAdapter());  // 👈 MUST BE FIRST

  /// THEN OPEN BOX
  final box = await Hive.openBox<ProductModel>('products_box');

  sl.registerLazySingleton<Box<ProductModel>>(() => box);


  sl.registerLazySingleton<ProductLocalDataSource>(
          () => ProductLocalDataSourceImpl(sl()));

  // sl.registerLazySingleton<ProductRemoteDataSource>(
  //         () => ProductRemoteDataSourceImpl(sl()));

  sl.registerLazySingleton<ProductRemoteDataSource>(
        () => ProductRemoteDataSourceImpl(sl<Dio>()),
  );

  sl.registerLazySingleton<ProductRepository>(
          () => ProductRepositoryImpl(sl(), sl()));


// Connectivity Service
  sl.registerLazySingleton(() => ConnectivityService(sl()));

// Usecase
  sl.registerLazySingleton(() => SyncProducts(sl()));

// Sync Service
  sl.registerLazySingleton(() => SyncService(sl(), sl()));


// Usecases
  sl.registerLazySingleton(() => GetProducts(sl()));

// Controller
  sl.registerFactory(() => ProductListController(sl(), sl()));

  sl.registerLazySingleton(() => GetProductDetail(sl()));
  sl.registerFactory(() => ProductDetailController(sl()));

  sl.registerLazySingleton(() => CreateProduct(sl()));
  sl.registerLazySingleton(() => UpdateProduct(sl()));
  sl.registerFactory(() => ProductFormController(sl(), sl()));

}

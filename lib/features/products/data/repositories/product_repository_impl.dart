

import 'package:dio/dio.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource local;
  final ProductRemoteDataSource remote;

  ProductRepositoryImpl(this.local, this.remote);

  @override
  Future<List<Product>> getProducts({required String page}) async {
    try {
      final remoteProducts = await remote.getProducts(page);
      await local.cacheProducts(remoteProducts);
    } catch (_) {}

    final localProducts = await local.getProducts();
    return localProducts.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Product> getProductDetail(String id) async {
    final localProducts = await local.getProducts();
    return localProducts.firstWhere((p) => p.id == id).toEntity();
  }

  @override
  Future<void> createProduct(Product product) async {
    final model = ProductModel.fromEntity(
      product.copyWith(isSynced: false),
      syncAction: 'create',
    );
    await local.saveProduct(model);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final model = ProductModel.fromEntity(
      product.copyWith(isSynced: false),
      syncAction: 'update',
    );
    await local.saveProduct(model);
  }

  // @override
  // Future<void> syncProducts() async {
  //   final unsynced = await local.getUnsyncedProducts();
  //
  //   for (var product in unsynced) {
  //     try {
  //       if (product.syncAction == 'create') {
  //         await remote.createProduct(product);
  //       } else {
  //         await remote.updateProduct(product);
  //       }
  //
  //       final synced = ProductModel(
  //         id: product.id,
  //         name: product.name,
  //         price: product.price,
  //         description: product.description,
  //         status: product.status,
  //         updatedAt: DateTime.now(),
  //         isSynced: true,
  //       );
  //
  //       await local.saveProduct(synced);
  //     } catch (_) {
  //       // retry later
  //     }
  //   }
  // }

  @override
  Future<void> syncProducts() async {
    final unsynced = await local.getUnsyncedProducts();

    for (var product in unsynced) {
      try {
        if (product.syncAction == 'update') {
          try {
            await remote.updateProduct(product);
          } on DioException catch (e) {
            if (e.response?.statusCode == 409) {
              // Fetch latest server version
              final server = await remote.getProductDetail(product.id.toString());

              // Save both versions locally with conflict flag
              final conflictModel = ProductModel(
                id: product.id,
                name: product.name,
                price: product.price,
                description: product.description,
                status: product.status,
                updatedAt: product.updatedAt,
                isSynced: false,
                syncAction: 'conflict',
              );

              await local.saveProduct(conflictModel);
              continue;
            }
          }
        }

        if (product.syncAction == 'create') {
          await remote.createProduct(product);
        }

        // Mark as synced
        final synced = ProductModel.fromJson(product.toJson());
        await local.saveProduct(synced);

      } catch (_) {
        // keep for retry
      }
    }
  }

}

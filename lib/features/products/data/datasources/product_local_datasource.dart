import 'package:hive/hive.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts();
  Future<void> cacheProducts(List<ProductModel> products);
  Future<void> saveProduct(ProductModel product);
  Future<List<ProductModel>> getUnsyncedProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Box<ProductModel> box;

  ProductLocalDataSourceImpl(this.box);

  @override
  Future<List<ProductModel>> getProducts() async {
    return box.values.toList();
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    for (var product in products) {
      //await box.put(product.id, product);
      await box.put(product.id.toString(), product);
    }
  }

  @override
  Future<void> saveProduct(ProductModel product) async {
    //await box.put(product.id, product);
    await box.put(product.id.toString(), product);

  }

  @override
  Future<List<ProductModel>> getUnsyncedProducts() async {
    return box.values.where((p) => !p.isSynced).toList();
  }
}


import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({required String page});
  Future<Product> getProductDetail(String id);

  Future<void> createProduct(Product product);
  Future<void> updateProduct(Product product);

  /// Push unsynced local changes to server
  Future<void> syncProducts();
}

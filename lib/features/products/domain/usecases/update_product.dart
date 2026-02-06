import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class UpdateProduct {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  Future<void> call(Product product) {
    return repository.updateProduct(product);
  }
}

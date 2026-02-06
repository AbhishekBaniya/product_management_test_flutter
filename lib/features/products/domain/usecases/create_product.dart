import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class CreateProduct {
  final ProductRepository repository;

  CreateProduct(this.repository);

  Future<void> call(Product product) {
    return repository.createProduct(product);
  }
}

import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductDetail {
  final ProductRepository repository;

  GetProductDetail(this.repository);

  Future<Product> call(String id) {
    return repository.getProductDetail(id);
  }
}

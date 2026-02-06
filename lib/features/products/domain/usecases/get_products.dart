import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<List<Product>> call(String page) {
    return repository.getProducts(page: page);
  }
}

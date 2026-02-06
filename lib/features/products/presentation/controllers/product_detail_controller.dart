import 'package:get/get.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_product_detail.dart';

class ProductDetailController extends GetxController {
  final GetProductDetail getProductDetail;

  ProductDetailController(this.getProductDetail);

  var product = Rxn<Product>();
  var isLoading = false.obs;
  var isError = false.obs;

  Future<void> loadProduct(String id) async {
    try {
      isLoading.value = true;
      final result = await getProductDetail(id);
      product.value = result;
      isError.value = false;
    } catch (_) {
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}

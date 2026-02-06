import 'package:get/get.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/update_product.dart';

class ProductFormController extends GetxController {
  final CreateProduct createProduct;
  final UpdateProduct updateProduct;

  ProductFormController(this.createProduct, this.updateProduct);

  var isSaving = false.obs;

  Future<void> saveProduct(Product product, bool isEdit) async {
    try {
      isSaving.value = true;

      if (isEdit) {
        await updateProduct(product);
      } else {
        await createProduct(product);
      }

      Get.back(); // go back after save
    } finally {
      isSaving.value = false;
    }
  }
}

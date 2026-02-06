import 'package:get/get.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/sync_product.dart';

/*class ProductListController extends GetxController {
  final GetProducts getProductsUseCase;
  final SyncProducts syncProductsUseCase;

  ProductListController(this.getProductsUseCase, this.syncProductsUseCase);

  var products = <Product>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;
  var currentPage = 1;
  var hasMore = true.obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts({bool loadMore = false}) async {
    try {
      if (!loadMore) {
        isLoading.value = true;
        currentPage = 1;
      }

      final newProducts = await getProductsUseCase(currentPage);

      if (loadMore) {
        products.addAll(newProducts);
      } else {
        products.assignAll(newProducts);
      }

      hasMore.value = newProducts.isNotEmpty;
      currentPage++;
      isError.value = false;
    } catch (_) {
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProducts() async {
    currentPage = 1;
    await fetchProducts();
    await syncProductsUseCase(); // Try sync when user refreshes
  }
}*/
class ProductListController extends GetxController {
  final GetProducts getProductsUseCase;
  final SyncProducts syncProductsUseCase;

  ProductListController(this.getProductsUseCase, this.syncProductsUseCase);

  var products = <Product>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;
  var hasMore = true.obs;

  int currentPage = 1;
  bool _isFetchingMore = false;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts({bool loadMore = false}) async {
    if (_isFetchingMore) return;

    try {
      if (loadMore) {
        _isFetchingMore = true;
      } else {
        isLoading.value = true;
        currentPage = 1;
      }

      final newProducts = await getProductsUseCase(currentPage.toString());

      if (loadMore) {
        products.addAll(newProducts);
      } else {
        products.assignAll(newProducts);
      }

      hasMore.value = newProducts.isNotEmpty;
      if (hasMore.value) currentPage++;

      isError.value = false;
    } catch (_) {
      isError.value = true;
    } finally {
      isLoading.value = false;
      _isFetchingMore = false;
    }
  }

  Future<void> refreshProducts() async {
    await fetchProducts();
    await syncProductsUseCase();
  }
}

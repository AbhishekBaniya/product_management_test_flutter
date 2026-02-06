import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant_products_app/features/products/presentation/pages/product_detail_page.dart';
import 'package:merchant_products_app/features/products/presentation/pages/product_form_page.dart';
import '../../../../injection_container.dart';
import '../controllers/product_list_controller.dart';

import '../widgets/offline_banner.dart';
import '../widgets/product_card.dart';

class ProductListPage extends StatelessWidget {
   const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {

    final ProductListController controller =
    Get.put(sl<ProductListController>(), permanent: true);
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.isError.value) {
                return Center(
                  child: ElevatedButton(
                    onPressed: controller.fetchProducts,
                    child: const Text('Retry'),
                  ),
                );
              }

              if (controller.products.isEmpty) {
                return const Center(child: Text('No products available'));
              }

              return RefreshIndicator(
                onRefresh: controller.refreshProducts,
                child: ListView.builder(

                  itemCount: controller.products.length +
                      (controller.hasMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < controller.products.length) {
                      final product = controller.products[index];

                      return GestureDetector(
                        onTap: () => Get.to(
                              () => ProductDetailPage(productId: product.id.toString()),
                        ),
                        child: ProductCard(product: product),
                      );
                    } else {
                      // Load-more indicator (ONLY UI)
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const ProductFormPage()),
        child: const Icon(Icons.add),
      ),
    );
  }
}

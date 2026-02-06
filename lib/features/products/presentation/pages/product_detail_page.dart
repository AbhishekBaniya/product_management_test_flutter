import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant_products_app/features/products/presentation/pages/product_form_page.dart';
import '../controllers/product_detail_controller.dart';
import '../../../../injection_container.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(sl<ProductDetailController>());
    controller.loadProduct(productId);

    return Scaffold(
      appBar: AppBar(title: const Text("Product Detail")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.isError.value || controller.product.value == null) {
          return const Center(child: Text("Failed to load product"));
        }

        final product = controller.product.value!;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(product.description),
              const SizedBox(height: 8),
              Text("Price: ₹${product.price}"),
              const SizedBox(height: 8),
              Text("Status: ${product.status}"),
              const SizedBox(height: 8),
              Text("Updated: ${product.updatedAt}"),
              if (!product.isSynced)
                const Text("Pending Sync",
                    style: TextStyle(color: Colors.orange)),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Get.to(() => ProductFormPage(product: product)),
                child: const Text("Edit Product"),
              )
            ],
          ),
        );
      }),
    );
  }
}

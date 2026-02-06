import 'package:flutter/material.dart';

import '../../domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text(product.description),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("₹${product.price}"),
          if (!product.isSynced)
            const Text("Pending Sync",
                style: TextStyle(color: Colors.orange, fontSize: 12)),
          if (product.hasConflict)
            const Text("Conflict", style: TextStyle(color: Colors.red, fontSize: 12))

        ],
      ),
    );
  }
}

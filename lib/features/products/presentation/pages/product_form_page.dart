import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/product_entity.dart';
import '../controllers/product_form_controller.dart';
import '../../../../injection_container.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product;
  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl;
  late TextEditingController descCtrl;
  late TextEditingController priceCtrl;
  String status = 'draft';

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.product?.name ?? '');
    descCtrl = TextEditingController(text: widget.product?.description ?? '');
    priceCtrl = TextEditingController(text: widget.product?.price.toString() ?? '');
    status = widget.product?.status ?? 'draft';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(sl<ProductFormController>());
    final isEdit = widget.product != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Product" : "Create Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
              TextFormField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
              TextFormField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price')),
              DropdownButtonFormField(
                value: status,
                items: const [
                  DropdownMenuItem(value: 'draft', child: Text('Draft')),
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                ],
                onChanged: (v) => status = v!,
              ),
              const SizedBox(height: 20),
              Obx(() => controller.isSaving.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () {
                  final product = Product(
                    id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameCtrl.text,
                    description: descCtrl.text,
                    price: int.parse(priceCtrl.text),
                    status: status,
                    updatedAt: DateTime.now(),
                    isSynced: false,
                  );

                  controller.saveProduct(product, isEdit);
                },
                child: const Text("Save"),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

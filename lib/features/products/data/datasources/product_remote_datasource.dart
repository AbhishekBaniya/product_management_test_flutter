import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts(String page);
  Future<ProductModel> getProductDetail(String id);
  Future<void> createProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio){
    debugPrint('DIO BASE URL 👉 ${dio.options.baseUrl}');
  }



  @override
  Future<List<ProductModel>> getProducts(String page) async {
    final response =
    await dio.get('/products', queryParameters: {'_page': page, '_limit': 20});
    print(response.statusCode);print(response);
    print(response.data);
    return (response.data as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();


  }

  @override
  Future<ProductModel> getProductDetail(String id) async {
    final response = await dio.get('/products/$id');
    print(response.statusCode);print(response);
    print(response.data);
    return ProductModel.fromJson(response.data);
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    await dio.post('/products', data: product.toJson());
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await dio.put('/products/${product.id}', data: product.toJson());
  }
}

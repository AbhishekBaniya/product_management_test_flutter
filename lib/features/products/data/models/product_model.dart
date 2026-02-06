import 'package:hive/hive.dart';
import '../../domain/entities/product_entity.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int price;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String status;

  @HiveField(5)
  final DateTime updatedAt;

  @HiveField(6)
  final bool isSynced;

  @HiveField(7)
  final String syncAction; // "create" or "update"

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.status,
    required this.updatedAt,
    this.isSynced = true,
    this.syncAction = '',
  });

  /// API → Model
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      description: json['description'],
      status: json['status'],
      updatedAt: DateTime.parse(json['updatedAt']),
      isSynced: true,
    );
  }

  /// Model → API
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "description": description,
    "status": status,
    "updatedAt": updatedAt.toIso8601String(),
  };

  /// Model → Entity
  Product toEntity() => Product(
    id: id,
    name: name,
    price: price,
    description: description,
    status: status,
    updatedAt: updatedAt,
    isSynced: isSynced,
  );

  /// Entity → Model
  factory ProductModel.fromEntity(Product product,
      {String syncAction = ''}) {
    return ProductModel(
      id: product.id,
      name: product.name,
      price: product.price,
      description: product.description,
      status: product.status,
      updatedAt: product.updatedAt,
      isSynced: product.isSynced,
      syncAction: syncAction,
    );
  }
}

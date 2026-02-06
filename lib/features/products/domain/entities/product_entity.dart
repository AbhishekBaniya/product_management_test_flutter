import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final int price;
  final String description;
  final String status;
  final DateTime updatedAt;
  final bool isSynced;
  final bool hasConflict;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.status,
    required this.updatedAt,
    this.isSynced = true,
    this.hasConflict = false,
  });

  Product copyWith({
    String? id,
    String? name,
    int? price,
    String? description,
    String? status,
    DateTime? updatedAt,
    bool? isSynced,
    bool? hasConflict,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      hasConflict: hasConflict ?? this.hasConflict,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, price, description, status, updatedAt, isSynced, hasConflict];
}

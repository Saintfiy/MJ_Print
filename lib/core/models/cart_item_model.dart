import 'package:get/get.dart';
import 'product_model.dart';

class CartItemModel {
  final String id;
  final ProductModel product;
  final int quantity;
  final String size;
  final String? notes;
  final RxBool isSelected;

  CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.size,
    this.notes,
    bool isSelected = false,
  }) : isSelected = isSelected.obs;

  double get totalPrice => product.basePrice * quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'size': size,
      'notes': notes,
      'isSelected': isSelected.value,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? '',
      product: ProductModel.fromJson(json['product'] ?? {}),
      quantity: json['quantity'] ?? 1,
      size: json['size'] ?? '',
      notes: json['notes'],
      isSelected: json['isSelected'] ?? false,
    );
  }
}
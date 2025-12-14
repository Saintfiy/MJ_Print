import 'package:flutter/material.dart'; // IMPORT INI DITAMBAHKAN
import 'package:get/get.dart';
import 'package:mj_print/core/models/product_model.dart';
import 'package:mj_print/core/models/cart_item_model.dart';
import 'package:mj_print/app/modules/cart/cart_controller.dart';

class OrderController extends GetxController {
  final CartController _cartController = Get.find();

  final RxInt quantity = 1.obs;
  final RxString selectedSize = ''.obs;
  final RxString notes = ''.obs;
  final RxDouble totalPrice = 0.0.obs;

  ProductModel? product;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      if (arguments is Map<String, dynamic>) {
        product = ProductModel.fromJson(arguments);
      } else if (arguments is ProductModel) {
        product = arguments;
      }
      
      if (product != null && product!.sizes.isNotEmpty) {
        selectedSize.value = product!.sizes.first;
      }
      _calculateTotal();
    }
  }

  void increaseQuantity() {
    quantity.value++;
    _calculateTotal();
  }

  void decreaseQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
      _calculateTotal();
    }
  }

  void updateSize(String size) {
    selectedSize.value = size;
    _calculateTotal();
  }

  void updateNotes(String newNotes) {
    notes.value = newNotes;
  }

  void _calculateTotal() {
    if (product != null) {
      totalPrice.value = product!.basePrice * quantity.value;
    }
  }

  void addToCart() {
    if (product == null) {
      Get.snackbar('Error', 'Produk tidak valid');
      return;
    }

    if (selectedSize.value.isEmpty) {
      Get.snackbar('Error', 'Pilih ukuran terlebih dahulu');
      return;
    }

    final cartItem = CartItemModel(
      id: '${product!.id}_${selectedSize.value}_${DateTime.now().millisecondsSinceEpoch}',
      product: product!,
      size: selectedSize.value,
      quantity: quantity.value,
      notes: notes.value.isEmpty ? null : notes.value,
    );

    _cartController.addToCart(cartItem);

    Get.back();
    
    // PERBAIKAN: Colors sudah tersedia karena import Material.dart
    Get.snackbar(
      'Berhasil',
      '${product!.name} ditambahkan ke keranjang',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void setProduct(ProductModel newProduct) {
    product = newProduct;
    if (product!.sizes.isNotEmpty) {
      selectedSize.value = product!.sizes.first;
    }
    _calculateTotal();
    update();
  }

  double get basePrice => product?.basePrice ?? 0.0;
  String get productName => product?.name ?? '';
  String get productDescription => product?.description ?? '';
  String get productIcon => product?.icon ?? '';
  List<String> get sizes => product?.sizes ?? [];
  String get unit => product?.unit ?? '';
}
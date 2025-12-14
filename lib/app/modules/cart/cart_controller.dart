import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mj_print/core/services/hive_service.dart';
import 'package:mj_print/core/models/cart_item_model.dart'; // Pastikan import model

class CartController extends GetxController {
  late final HiveService hiveService;
  
  // Tambahkan properti yang diperlukan
  var cartItems = <CartItemModel>[].obs;
  var totalAmount = 0.0.obs;
  
  bool get isCartEmpty => cartItems.isEmpty;

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<HiveService>()) {
      hiveService = Get.find<HiveService>();
    }
    // Load cart data dari Hive jika perlu
    _loadCartData();
  }

  void _loadCartData() {
    // Implementasi load data dari Hive
  }

  void removeFromCart(String itemId) {
    cartItems.removeWhere((item) => item.id == itemId);
    _calculateTotal();
  }

  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(itemId);
      return;
    }
    
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      // Buat item baru dengan quantity yang diperbarui
      final updatedItem = CartItemModel(
        id: cartItems[index].id,
        product: cartItems[index].product,
        size: cartItems[index].size,
        quantity: newQuantity,
        notes: cartItems[index].notes,
      );
      cartItems[index] = updatedItem;
      _calculateTotal();
    }
  }

  void _calculateTotal() {
    double total = 0;
    for (final item in cartItems) {
      total += item.totalPrice;
    }
    totalAmount.value = total;
  }

  void clearCart() {
    cartItems.clear();
    totalAmount.value = 0;
  }

  void checkout() {
    // Implementasi checkout
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Keranjang Kosong',
        'Tambahkan produk ke keranjang terlebih dahulu',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Navigasi ke halaman checkout
    Get.toNamed('/checkout');
  }

  void addToCart(CartItemModel item) {
    // Cek apakah item sudah ada di cart
    final existingIndex = cartItems.indexWhere(
      (cartItem) => cartItem.id == item.id && cartItem.size == item.size
    );
    
    if (existingIndex != -1) {
      // Update quantity jika sudah ada
      updateQuantity(item.id, cartItems[existingIndex].quantity + item.quantity);
    } else {
      // Tambahkan item baru
      cartItems.add(item);
      _calculateTotal();
    }
    
    Get.snackbar(
      'Berhasil',
      'Produk ditambahkan ke keranjang',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
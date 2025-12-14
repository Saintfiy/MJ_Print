import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_controller.dart';
import 'package:mj_print/core/models/cart_item_model.dart'; // Import model

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        actions: [
          Obx(() => controller.isCartEmpty
              ? Container()
              : IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: _showClearCartDialog,
                )),
        ],
      ),
      body: Obx(
          () => controller.isCartEmpty ? _buildEmptyCart() : _buildCartItems()),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 100, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'Keranjang Kosong',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Belum ada produk yang ditambahkan',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.until((route) => Get.currentRoute == '/home'),
            child: const Text('Jelajahi Produk'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.cartItems.length,
            itemBuilder: (context, index) {
              final item = controller.cartItems[index];
              return _buildCartItem(item);
            },
          ),
        ),
        _buildCheckoutSection(),
      ],
    );
  }

  Widget _buildCartItem(CartItemModel item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Ganti dengan image atau icon yang sesuai
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.print, color: Colors.grey[500]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ukuran: ${item.size}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      Text(
                        'Jumlah: ${item.quantity} ${item.product.unit}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      if (item.notes != null && item.notes!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Catatan: ${item.notes}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.removeFromCart(item.id),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuantityControls(item),
                Text(
                  'Rp ${item.totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControls(CartItemModel item) {
    return Row(
      children: [
        IconButton(
          onPressed: () =>
              controller.updateQuantity(item.id, item.quantity - 1),
          icon: const Icon(Icons.remove_circle, color: Colors.red),
        ),
        Container(
          width: 40,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            item.quantity.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          onPressed: () =>
              controller.updateQuantity(item.id, item.quantity + 1),
          icon: const Icon(Icons.add_circle, color: Colors.green),
        ),
      ],
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.3 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Obx(() => Text(
                    'Rp ${controller.totalAmount.value.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2196F3),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: controller.checkout,
              child: const Text(
                'Checkout',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Semua'),
        content: const Text('Yakin ingin mengosongkan keranjang?'),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.clearCart();
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

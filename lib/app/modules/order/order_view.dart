import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'order_controller.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not already done
    Get.put(OrderController());

    if (controller.product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Produk tidak ditemukan')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Form Pemesanan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductHeader(),
            const SizedBox(height: 24),
            _buildSizeSelection(),
            const SizedBox(height: 24),
            _buildQuantitySelection(),
            const SizedBox(height: 24),
            _buildNotesInput(),
            const SizedBox(height: 24),
            _buildPriceSummary(),
            const SizedBox(height: 24),
            _buildAddToCartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductHeader() {
    return Center(
      child: Column(
        children: [
          Text(
            controller.productIcon,
            style: const TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 16),
          Text(
            controller.productName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            controller.productDescription,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Ukuran',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: controller.selectedSize.value.isEmpty
              ? null
              : controller.selectedSize.value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: controller.sizes.map((size) {
            return DropdownMenuItem<String>(
              value: size,
              child: Text(size),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              controller.updateSize(value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildQuantitySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jumlah',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: controller.decreaseQuantity,
              icon: const Icon(Icons.remove_circle),
              color: const Color(0xFF2196F3),
            ),
            Obx(() => Container(
                  width: 80,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    controller.quantity.value.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )),
            IconButton(
              onPressed: controller.increaseQuantity,
              icon: const Icon(Icons.add_circle),
              color: const Color(0xFF2196F3),
            ),
            const Spacer(),
            Text(
              controller.unit,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catatan (Opsional)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: controller.updateNotes,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Tambahkan catatan untuk pesanan...',
            contentPadding: EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2196F3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Harga Satuan:', style: TextStyle(fontSize: 16)),
              Text(
                'Rp ${controller.basePrice.toStringAsFixed(0)}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Jumlah:', style: TextStyle(fontSize: 16)),
                  Text(
                    '${controller.quantity.value} ${controller.unit}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              )),
          const Divider(height: 24),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Rp ${controller.totalPrice.value.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return ElevatedButton(
      onPressed: controller.addToCart,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
      ),
      child: const Text(
        'Tambah ke Keranjang',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

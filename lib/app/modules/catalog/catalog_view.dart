import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'catalog_controller.dart';
import '../order/order_view.dart';
import 'package:mj_print/core/models/product_model.dart';

class CatalogView extends GetView<CatalogController> {
  const CatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: _buildProductGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 70, // ✅ TAMBAH SEDIKIT HEIGHT
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          return Obx(() => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: controller.selectedCategory.value == category,
                  onSelected: (selected) {
                    controller.filterByCategory(category);
                  },
                ),
              ));
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.filteredProducts.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Tidak ada produk ditemukan',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.68, // ✅ PERBAIKAN: Kurangi dari 0.75 ke 0.68
        ),
        itemCount: controller.filteredProducts.length,
        itemBuilder: (context, index) {
          final product = controller.filteredProducts[index];
          return _buildProductCard(product);
        },
      );
    });
  }

  Widget _buildProductCard(ProductModel product) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Get.to(
            () => const OrderView(),
            arguments: product.toJson(),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ PERBAIKAN: Container image dengan height fixed
            Container(
              height: 110, // ✅ KURANGI DARI 120 KE 110
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF2196F3).withAlpha((0.1 * 255).round()),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: Text(product.icon,
                    style: const TextStyle(fontSize: 50) // ✅ KECILKAN FONT ICON
                    ),
              ),
            ),
            // ✅ PERBAIKAN: Padding content dengan height yang lebih compact
            Padding(
              padding: const EdgeInsets.all(10), // ✅ KURANGI DARI 12 KE 10
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14, // ✅ KECILKAN DARI 16 KE 14
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2), // ✅ KURANGI DARI 4 KE 2
                  Text(
                    product.description,
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600]), // ✅ KECILKAN DARI 12 KE 11
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6), // ✅ KURANGI DARI 8 KE 6
                  Text(
                    'Rp ${product.basePrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 13, // ✅ KECILKAN DARI 14 KE 13
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                  Text(
                    product.unit,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500]), // ✅ KECILKAN DARI 11 KE 10
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('Cari Produk'),
        content: TextField(
          onChanged: controller.searchProducts,
          decoration: const InputDecoration(
            hintText: 'Masukkan nama produk...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.clearFilters();
              Get.back();
            },
            child: const Text('Reset'),
          ),
          TextButton(
            onPressed: Get.back,
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}

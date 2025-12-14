import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mj_print/app/routes/app_routes.dart'; // Tambahkan import ini
import 'home_controller.dart';
import '../catalog/catalog_view.dart';
import '../cart/cart_view.dart';
import '../profile/profile_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(), // PERBAIKAN: Pindah AppBar ke atas
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: [
              _HomePage(), // PERBAIKAN: Hapus const
              CatalogView(),
              CartView(),
              ProfileView(),
            ],
          )),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar? _buildAppBar() {
    // PERBAIKAN: Hanya tampilkan AppBar di halaman Home
    return controller.currentIndex.value == 0
        ? AppBar(
            title: const Text('MJ Print - Percetakan'),
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: controller.navigateToCart,
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: controller.navigateToProfile,
              ),
            ],
          )
        : null;
  }

  Widget _buildBottomNavigationBar() {
    return Obx(() => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTabIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF2196F3),
          unselectedItemColor: Colors.grey,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: 'Katalog',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                label: Text(controller.cartItemCount.value.toString()),
                isLabelVisible:
                    controller.cartItemCount.value > 0, // PERBAIKAN: .value
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Keranjang',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ));
  }
}

class _HomePage extends GetView<HomeController> {
  const _HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2196F3).withAlpha((0.1 * 255).round()),
            Colors.white,
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withAlpha((0.3 * 255).round()),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.print,
                          size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'MJ Print',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                    const Text(
                      'Solusi Percetakan Digital Terpercaya',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Layanan Percetakan',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuCard(
                      icon: Icons.store,
                      title: 'Katalog Produk',
                      subtitle: 'Lihat semua produk percetakan',
                      color: Colors.blue,
                      onTap: () => controller.changeTabIndex(1),
                    ),
                    _buildMenuCard(
                      icon: Icons.shopping_bag,
                      title: 'Keranjang Belanja',
                      subtitle: 'Lihat pesanan Anda',
                      color: Colors.green,
                      onTap: controller.navigateToCart,
                    ),
                    _buildMenuCard(
                      icon: Icons.history,
                      title: 'Riwayat Pesanan',
                      subtitle: 'Track status pesanan',
                      color: Colors.orange,
                      onTap: () => Get.toNamed(
                          AppRoutes.HISTORY), // PERBAIKAN: AppRoutes
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Eksperimen Teknis',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    _buildMenuCard(
                      icon: Icons.location_on,
                      title: 'Lokasi & Peta',
                      subtitle: 'GPS dan tracking',
                      color: Colors.teal,
                      onTap: () => Get.toNamed(
                          AppRoutes.LOCATION), // PERBAIKAN: AppRoutes
                    ),
                    _buildMenuCard(
                      icon: Icons.settings,
                      title: 'Pengaturan',
                      subtitle: 'Tema dan preferensi',
                      color: Colors.red,
                      onTap: () => Get.toNamed(
                          AppRoutes.SETTINGS), // PERBAIKAN: AppRoutes
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

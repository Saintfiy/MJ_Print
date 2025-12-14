import 'package:get/get.dart';
import 'package:mj_print/core/services/auth_service.dart';
import 'package:mj_print/app/routes/app_routes.dart'; // Tambahkan import ini

class HomeController extends GetxController {
  final AuthService _authService = Get.find();

  final RxInt currentIndex = 0.obs;
  final RxString appTitle = 'MJ Print'.obs;
  final RxInt cartItemCount = 0.obs; // PERBAIKAN: Tambahkan cartItemCount

  // User info
  String get userName => _authService.currentUser?.name ?? 'Customer';
  String get userEmail => _authService.currentUser?.email ?? '';
  String? get userAvatar => _authService.currentUser?.avatar;

  @override
  void onInit() {
    super.onInit();
    _updateAppTitle();
  }

  void changeTabIndex(int index) {
    currentIndex.value = index;
    _updateAppTitle();
  }

  void _updateAppTitle() {
    switch (currentIndex.value) {
      case 0:
        appTitle.value = 'MJ Print';
        break;
      case 1:
        appTitle.value = 'Katalog';
        break;
      case 2:
        appTitle.value = 'Keranjang';
        break;
      case 3:
        appTitle.value = 'Profil';
        break;
    }
  }

  // PERBAIKAN: Tambahkan method untuk navigasi
  void navigateToCart() {
    currentIndex.value = 2;
    _updateAppTitle();
  }

  void navigateToProfile() {
    currentIndex.value = 3;
    _updateAppTitle();
  }

  void logout() {
    _authService.logout();
    Get.offAllNamed(AppRoutes.AUTH); // PERBAIKAN: Gunakan AppRoutes
  }

  // Check if user is admin
  bool get isAdmin => _authService.currentUser?.role == 'admin';
  bool get isCustomer => _authService.currentUser?.role == 'customer';
}

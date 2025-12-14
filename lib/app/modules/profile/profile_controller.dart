import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mj_print/core/services/auth_service.dart';
import 'package:mj_print/core/models/user_model.dart';
import 'package:mj_print/core/utils/helpers.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find();

  final RxBool isLoading = false.obs;
  final RxBool isEditing = false.obs;

  final Rxn<UserModel> user = Rxn<UserModel>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      user.value = currentUser;
      nameController.text = currentUser.name;
      emailController.text = currentUser.email;
      phoneController.text = currentUser.phone ?? '';
      addressController.text = currentUser.address ?? '';
    } else {
      user.value = UserModel.empty();
    }
  }

  void toggleEditMode() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      loadUserData();
    }
  }

  Future<void> updateProfile() async {
    if (!_validateForm()) return;

    isLoading.value = true;

    try {
      final userData = {
        'full_name': nameController.text.trim(),
        'phone_number': phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        'address': addressController.text.trim().isEmpty
            ? null
            : addressController.text.trim(),
      };

      final updatedUser = await _authService.updateProfile(userData);

      if (updatedUser != null) {
        isEditing.value = false;
        Helpers.showSnackbar(
          title: 'Success',
          message: 'Profil berhasil diperbarui',
        );
      } else {
        Helpers.showSnackbar(
          title: 'Error',
          message: 'Gagal memperbarui profil',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Helpers.showSnackbar(
        title: 'Error',
        message: 'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    if (nameController.text.isEmpty) {
      Helpers.showSnackbar(
        title: 'Error',
        message: 'Nama tidak boleh kosong',
        backgroundColor: Colors.red,
      );
      return false;
    }

    if (phoneController.text.isNotEmpty &&
        !Helpers.isValidPhone(phoneController.text)) {
      Helpers.showSnackbar(
        title: 'Error',
        message: 'Nomor telepon tidak valid',
        backgroundColor: Colors.red,
      );
      return false;
    }

    return true;
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _performLogout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _performLogout() {
    _authService.logout();
    Get.offAllNamed('/auth');
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}

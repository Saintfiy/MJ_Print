import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mj_print/app/routes/app_routes.dart';
import 'package:mj_print/core/services/auth_service.dart';
import 'package:mj_print/core/utils/helpers.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find();

  final RxBool isLoading = false.obs;
  final RxBool isLoginMode = true.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Tunggu sebentar untuk inisialisasi auth service
    await Future.delayed(Duration(milliseconds: 500));

    if (_authService.isLoggedIn.value) {
      Get.offAllNamed(AppRoutes.HOME);
    }
  }

  void toggleAuthMode() {
    isLoginMode.value = !isLoginMode.value;
    clearFormErrors();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void clearFormErrors() {
    // Hanya clear form ketika toggle mode
    if (isLoginMode.value) {
      // Mode login: clear semua
      emailController.clear();
      passwordController.clear();
      nameController.clear();
      confirmPasswordController.clear();
    } else {
      // Mode register: hanya clear confirm password
      confirmPasswordController.clear();
    }
  }

  Future<void> submit() async {
    if (!_validateForm()) return;

    isLoading.value = true;

    try {
      if (isLoginMode.value) {
        await _login();
      } else {
        await _register();
      }
    } catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // PERBAIKAN: Menggunakan helper yang sudah ada
  Future<void> login() async {
    await submit();
  }

  Future<void> register() async {
    await submit();
  }

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final user = await _authService.login(email, password);

      if (user != null) {
        Helpers.showSnackbar(
          title: 'Berhasil',
          message: 'Login berhasil!',
          backgroundColor: Colors.green,
        );
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        Helpers.showSnackbar(
          title: 'Gagal',
          message: 'Email atau password salah',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      _handleAuthError(e);
    }
  }

  Future<void> _register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final fullName = nameController.text.trim();

    try {
      final user = await _authService.register(email, password, fullName);

      if (user != null) {
        Helpers.showSnackbar(
          title: 'Berhasil',
          message: 'Registrasi berhasil!',
          backgroundColor: Colors.green,
        );
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        Helpers.showSnackbar(
          title: 'Gagal',
          message: 'Registrasi gagal',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      _handleAuthError(e);
    }
  }

  bool _validateForm() {
    // Validate email
    if (emailController.text.isEmpty) {
      Helpers.showSnackbar(
        title: 'Perhatian',
        message: 'Email tidak boleh kosong',
        backgroundColor: Colors.orange,
      );
      return false;
    }

    if (!Helpers.isValidEmail(emailController.text)) {
      Helpers.showSnackbar(
        title: 'Perhatian',
        message: 'Format email tidak valid',
        backgroundColor: Colors.orange,
      );
      return false;
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      Helpers.showSnackbar(
        title: 'Perhatian',
        message: 'Password tidak boleh kosong',
        backgroundColor: Colors.orange,
      );
      return false;
    }

    if (passwordController.text.length < 6) {
      Helpers.showSnackbar(
        title: 'Perhatian',
        message: 'Password minimal 6 karakter',
        backgroundColor: Colors.orange,
      );
      return false;
    }

    // Validate registration fields
    if (!isLoginMode.value) {
      if (nameController.text.isEmpty) {
        Helpers.showSnackbar(
          title: 'Perhatian',
          message: 'Nama lengkap tidak boleh kosong',
          backgroundColor: Colors.orange,
        );
        return false;
      }

      if (confirmPasswordController.text.isEmpty) {
        Helpers.showSnackbar(
          title: 'Perhatian',
          message: 'Konfirmasi password tidak boleh kosong',
          backgroundColor: Colors.orange,
        );
        return false;
      }

      if (passwordController.text != confirmPasswordController.text) {
        Helpers.showSnackbar(
          title: 'Perhatian',
          message: 'Password dan konfirmasi password tidak cocok',
          backgroundColor: Colors.orange,
        );
        return false;
      }
    }

    return true;
  }

  void _handleAuthError(dynamic error) {
    String errorMessage = 'Terjadi kesalahan';

    final errorStr = error.toString();

    if (errorStr.contains('Invalid login credentials')) {
      errorMessage = 'Email atau password salah';
    } else if (errorStr.contains('User already registered')) {
      errorMessage = 'Email sudah terdaftar';
    } else if (errorStr.contains('Password should be at least')) {
      errorMessage = 'Password minimal 6 karakter';
    } else if (errorStr.contains('Email not confirmed')) {
      errorMessage = 'Email belum dikonfirmasi. Cek inbox email Anda';
    } else if (errorStr.contains('network') ||
        errorStr.contains('SocketException')) {
      errorMessage = 'Koneksi internet bermasalah. Periksa koneksi Anda';
    } else if (errorStr.contains('rate limit')) {
      errorMessage = 'Terlalu banyak percobaan. Coba lagi nanti';
    } else if (errorStr.contains('User not found')) {
      errorMessage = 'Email belum terdaftar';
    } else {
      errorMessage =
          'Error: ${errorStr.length > 100 ? errorStr.substring(0, 100) + '...' : errorStr}';
    }

    Helpers.showSnackbar(
      title: 'Gagal',
      message: errorMessage,
      backgroundColor: Colors.red,
    );
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      Get.offAllNamed(AppRoutes.AUTH);

      Helpers.showSnackbar(
        title: 'Berhasil',
        message: 'Logout berhasil',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      Helpers.showSnackbar(
        title: 'Gagal',
        message: 'Logout gagal: ${e.toString()}',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty || !Helpers.isValidEmail(email)) {
      Helpers.showSnackbar(
        title: 'Perhatian',
        message: 'Masukkan email yang valid',
        backgroundColor: Colors.orange,
      );
      return;
    }

    isLoading.value = true;
    Helpers.showLoading(message: 'Mengirim email reset password...');

    try {
      await _authService.resetPassword(email);
      Helpers.hideLoading();

      Helpers.showSnackbar(
        title: 'Berhasil',
        message: 'Link reset password telah dikirim ke $email',
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
      );
    } catch (e) {
      Helpers.hideLoading();

      String errorMessage = 'Gagal mengirim email reset password';
      if (e.toString().contains('User not found')) {
        errorMessage = 'Email belum terdaftar';
      }

      Helpers.showSnackbar(
        title: 'Gagal',
        message: errorMessage,
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Hapus method _showSuccess dan _showError karena sudah pakai Helpers

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

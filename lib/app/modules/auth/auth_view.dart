import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildForm(),
              const SizedBox(height: 24),
              _buildAuthButton(),
              const SizedBox(height: 16),
              _buildToggleAuthMode(),
              const SizedBox(height: 16),
              if (controller.isLoginMode.value) _buildForgotPassword(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.print, size: 32, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Obx(() => Text(
              controller.isLoginMode.value ? 'Selamat Datang' : 'Daftar Akun',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            )),
        const SizedBox(height: 8),
        Obx(() => Text(
              controller.isLoginMode.value
                  ? 'Masuk ke akun MJ Print Anda'
                  : 'Buat akun baru untuk mulai mencetak',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            )),
      ],
    );
  }

  Widget _buildForm() {
    return Obx(() => Column(
          children: [
            if (!controller.isLoginMode.value) ...[
              TextField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => TextField(
                  controller: controller.passwordController,
                  obscureText: controller.obscurePassword.value,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () => controller.togglePasswordVisibility(),
                    ),
                  ),
                )),
            const SizedBox(height: 16),
            if (!controller.isLoginMode.value) ...[
              Obx(() => TextField(
                    controller: controller.confirmPasswordController,
                    obscureText: controller.obscureConfirmPassword.value,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscureConfirmPassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () =>
                            controller.toggleConfirmPasswordVisibility(),
                      ),
                    ),
                  )),
              const SizedBox(height: 8),
            ],
          ],
        ));
  }

  Widget _buildAuthButton() {
    return Obx(() => SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () {
                    if (controller.isLoginMode.value) {
                      controller.login();
                    } else {
                      controller.register();
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    controller.isLoginMode.value ? 'Masuk' : 'Daftar',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ));
  }

  Widget _buildToggleAuthMode() {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              controller.isLoginMode.value
                  ? 'Belum punya akun?'
                  : 'Sudah punya akun?',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: controller.toggleAuthMode,
              child: Text(
                controller.isLoginMode.value ? 'Daftar' : 'Masuk',
                style: const TextStyle(
                  color: Color(0xFF2196F3),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildForgotPassword() {
    return Center(
      child: TextButton(
        onPressed: () {
          // Tampilkan dialog untuk input email reset password
          Get.dialog(
            AlertDialog(
              title: const Text('Reset Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Masukkan email untuk mengirim link reset password',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: TextEditingController(
                        text: controller.emailController.text),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      controller.emailController.text = value;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: Get.back,
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    controller.forgotPassword();
                  },
                  child: const Text('Kirim'),
                ),
              ],
            ),
          );
        },
        child: const Text(
          'Lupa Password?',
          style: TextStyle(color: Color(0xFF2196F3)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mj_print/app/routes/app_routes.dart';
import 'package:mj_print/core/services/auth_service.dart';
import 'package:mj_print/core/services/supabase_service.dart';
import 'dart:developer';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize services
      Get.put(SupabaseService());
      Get.put(AuthService());

      // Check auth status
      final authService = Get.find<AuthService>();
      await authService.checkAuthStatus();

      // Delay untuk animasi
      await Future.delayed(const Duration(seconds: 1));

      if (authService.isLoggedIn.value) {
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        Get.offAllNamed(AppRoutes.AUTH);
      }
    } catch (e) {
      log('❌ Splash error: $e');
      Get.offAllNamed(AppRoutes.AUTH);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.print, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'MJ Print',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

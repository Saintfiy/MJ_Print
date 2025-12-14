import 'package:get/get.dart';
import 'package:mj_print/app/modules/auth/auth_controller.dart';
import 'package:mj_print/core/services/supabase_service.dart';
import 'package:mj_print/core/services/auth_service.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    // Pastikan SupabaseService sudah ter-register
    if (!Get.isRegistered<SupabaseService>()) {
      Get.put(SupabaseService());
    }
    
    // Register AuthService
    Get.lazyPut<AuthService>(() => AuthService());
    
    // Register AuthController
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
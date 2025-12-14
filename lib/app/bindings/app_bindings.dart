import 'package:get/get.dart';
import 'package:mj_print/core/services/storage_service.dart';
import 'package:mj_print/core/services/hive_service.dart';
import 'package:mj_print/core/services/supabase_service.dart';
import 'package:mj_print/core/services/location_service.dart';
import 'package:mj_print/core/services/auth_service.dart';
import 'package:mj_print/data/repositories/auth_repository.dart';
import 'package:mj_print/data/repositories/product_repository.dart';
import 'package:mj_print/data/repositories/order_repository.dart';
import 'package:mj_print/data/repositories/location_repository.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut(() => StorageService());
    Get.lazyPut(() => HiveService());
    Get.lazyPut(() => SupabaseService());
    Get.lazyPut(() => LocationService());
    Get.lazyPut(() => AuthService());
    
    // Repositories
    Get.lazyPut(() => AuthRepository());
    Get.lazyPut(() => ProductRepository());
    Get.lazyPut(() => OrderRepository());
    Get.lazyPut(() => LocationRepository());
  }
}
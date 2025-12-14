import 'package:get/get.dart';
import 'package:mj_print/app/routes/app_routes.dart';

// Bindings
import '../bindings/auth_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/catalog_binding.dart';
import '../bindings/cart_binding.dart';
import '../bindings/order_binding.dart';
import '../bindings/profile_binding.dart';
import '../bindings/settings_binding.dart';

// Views
import '../modules/auth/auth_view.dart';
import '../modules/home/home_view.dart';
import '../modules/catalog/catalog_view.dart';
import '../modules/order/order_view.dart';
import '../modules/cart/cart_view.dart';
import '../modules/history/history_view.dart';
import '../modules/profile/profile_view.dart';
import '../modules/settings/settings_view.dart';
import '../modules/location/location_view.dart';
import '../modules/splash/splash_view.dart'; // IMPORT INI DITAMBAHKAN

class AppPages {
  AppPages._();

  static const INITIAL = AppRoutes.SPLASH;

  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () =>
          const SplashView(), // PERBAIKAN: Ganti dengan SplashView yang benar
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.CATALOG,
      page: () => const CatalogView(),
      binding: CatalogBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.ORDER,
      page: () => const OrderView(),
      binding: OrderBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.CART,
      page: () => const CartView(),
      binding: CartBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.HISTORY,
      page: () => const HistoryView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.LOCATION,
      page: () => const LocationView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}

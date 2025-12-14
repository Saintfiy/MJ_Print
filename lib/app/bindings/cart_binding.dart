import 'package:get/get.dart';
import 'package:mj_print/app/modules/cart/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(() => CartController());
  }
}
import 'package:get/get.dart';
import 'package:mj_print/app/modules/order/order_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(() => OrderController());
  }
}

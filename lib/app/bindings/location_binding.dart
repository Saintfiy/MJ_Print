import 'package:get/get.dart';
import 'package:mj_print/app/modules/location/location_controller.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationController>(() => LocationController());
  }
}
import 'package:get/get.dart';
import 'package:mj_print/app/modules/settings/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}

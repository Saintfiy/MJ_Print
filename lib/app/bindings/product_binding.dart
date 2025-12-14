import 'package:get/get.dart';
import 'package:mj_print/app/modules/catalog/catalog_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CatalogController>(() => CatalogController());
  }
}
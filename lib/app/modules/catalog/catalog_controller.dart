import 'package:get/get.dart';
import 'package:mj_print/core/models/product_model.dart';
import 'package:mj_print/data/repositories/product_repository.dart';

class CatalogController extends GetxController {
  final ProductRepository _productRepository = Get.find();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<ProductModel> filteredProducts = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'Semua'.obs;

  final List<String> categories = [
    'Semua',
    'Banner',
    'Kartu',
    'Brosur',
    'Stiker',
    'Kalender',
  ];

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    try {
      final productsList = await _productRepository.getProducts();
      products.assignAll(productsList);
      filteredProducts.assignAll(productsList);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat produk: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    _filterProducts();
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    _filterProducts();
  }

  void _filterProducts() {
    List<ProductModel> filtered = products;

    // Filter by category
    if (selectedCategory.value != 'Semua') {
      filtered = filtered.where((product) => 
        product.category == selectedCategory.value
      ).toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((product) => 
        product.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        product.description.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }

    filteredProducts.assignAll(filtered);
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedCategory.value = 'Semua';
    filteredProducts.assignAll(products);
  }

  List<ProductModel> getProductsByCategory(String category) {
    return products.where((product) => product.category == category).toList();
  }

  ProductModel? getProductById(String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}
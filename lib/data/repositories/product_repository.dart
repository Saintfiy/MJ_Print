import 'package:get/get.dart';
import 'package:mj_print/core/models/product_model.dart';
import 'package:mj_print/data/providers/product_provider.dart';
import 'package:mj_print/core/services/hive_service.dart';

class ProductRepository extends GetxService {
  final ProductProvider _productProvider = Get.find();
  final HiveService _hiveService = Get.find();

  // Get products with caching
  Future<List<ProductModel>> getProducts() async {
    try {
      // Try to get from local storage first
      final localProducts = await _hiveService.getProducts();
      if (localProducts.isNotEmpty) {
        return localProducts;
      }

      // If no local data, fetch from API
      final response = await _productProvider.getProductsFromSupabase();
      if (response.success && response.data != null) {
        final products = (response.data as List)
            .map((item) => ProductModel.fromJson(item))
            .toList();

        // Cache the products
        await _hiveService.saveProducts(products);
        return products;
      }

      // If API fails, return default products
      return ProductModel.getProducts();
    } catch (e) {
      // Return default products as fallback
      return ProductModel.getProducts();
    }
  }

  // Get products by category
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await _productProvider.getProductsByCategory(category);
      if (response.success && response.data != null) {
        return (response.data as List)
            .map((item) => ProductModel.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Search products
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await _productProvider.searchProducts(query);
      if (response.success && response.data != null) {
        return (response.data as List)
            .map((item) => ProductModel.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Add product
  Future<bool> addProduct(ProductModel product) async {
    try {
      final response = await _productProvider.addProduct(product);
      if (response.success) {
        // Refresh local cache
        await refreshProducts();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Update product
  Future<bool> updateProduct(ProductModel product) async {
    try {
      final response = await _productProvider.updateProduct(product);
      if (response.success) {
        // Refresh local cache
        await refreshProducts();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Delete product
  Future<bool> deleteProduct(String productId) async {
    try {
      final response = await _productProvider.deleteProduct(productId);
      if (response.success) {
        // Refresh local cache
        await refreshProducts();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Refresh products cache
  Future<void> refreshProducts() async {
    try {
      final response = await _productProvider.getProductsFromSupabase();
      if (response.success && response.data != null) {
        final products = (response.data as List)
            .map((item) => ProductModel.fromJson(item))
            .toList();
        await _hiveService.saveProducts(products);
      }
    } catch (e) {
      // Ignore error, keep existing cache
    }
  }

  // Compare HTTP vs Dio performance
  Future<Map<String, dynamic>> compareNetworkPerformance() async {
    final stopwatch = Stopwatch();

    // Test HTTP
    stopwatch.start();
    final httpResponse = await _productProvider.getProductsFromHttp();
    stopwatch.stop();
    final httpTime = stopwatch.elapsedMilliseconds;

    // Reset stopwatch
    stopwatch.reset();

    // Test Dio
    stopwatch.start();
    final dioResponse = await _productProvider.getProductsFromDio();
    stopwatch.stop();
    final dioTime = stopwatch.elapsedMilliseconds;

    return {
      'http': {
        'time': httpTime,
        'success': httpResponse.success,
        'data': httpResponse.data,
      },
      'dio': {
        'time': dioTime,
        'success': dioResponse.success,
        'data': dioResponse.data,
      },
    };
  }
}

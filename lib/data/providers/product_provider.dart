import 'package:get/get.dart';
import 'package:mj_print/core/services/supabase_service.dart';
import 'package:mj_print/core/services/http_service.dart';
import 'package:mj_print/core/services/dio_service.dart';
import 'package:mj_print/core/models/simple_response_model.dart';
import 'package:mj_print/core/models/product_model.dart';

class ProductProvider extends GetxService {
  final SupabaseService _supabaseService = Get.find();
  final HttpService _httpService = HttpService();
  final DioService _dioService = DioService();

  // Get products from Supabase
  Future<SimpleResponseModel> getProductsFromSupabase() async {
    try {
      final response = await _supabaseService.getData('products');
      return SimpleResponseModel(
          success: true, message: 'Products fetched', data: response);
    } catch (e) {
      return SimpleResponseModel(success: false, message: e.toString());
    }
  }

  // Get products from HTTP API
  Future<SimpleResponseModel> getProductsFromHttp() async {
    return await _httpService.get('products');
  }

  // Get products from Dio
  Future<SimpleResponseModel> getProductsFromDio() async {
    return await _dioService.get('/products');
  }

  // Add product to Supabase
  Future<SimpleResponseModel> addProduct(ProductModel product) async {
    try {
      final response =
          await _supabaseService.insertData('products', product.toJson());
      return SimpleResponseModel(
          success: true, message: 'Product added', data: response);
    } catch (e) {
      return SimpleResponseModel(success: false, message: e.toString());
    }
  }

  // Update product in Supabase
  Future<SimpleResponseModel> updateProduct(ProductModel product) async {
    try {
      final response = await _supabaseService.updateData(
        'products',
        product.id,
        product.toJson(),
      );
      return SimpleResponseModel(
          success: true, message: 'Product updated', data: response);
    } catch (e) {
      return SimpleResponseModel(success: false, message: e.toString());
    }
  }

  // Delete product from Supabase
  Future<SimpleResponseModel> deleteProduct(String productId) async {
    try {
      await _supabaseService.deleteData('products', productId);
      return SimpleResponseModel(success: true, message: 'Product deleted');
    } catch (e) {
      return SimpleResponseModel(success: false, message: e.toString());
    }
  }

  // Get product by ID
  Future<SimpleResponseModel> getProductById(String productId) async {
    try {
      final response = await _supabaseService
          .getData('products', filters: {'id': productId});
      return SimpleResponseModel(
          success: true, message: 'Product fetched', data: response);
    } catch (e) {
      return SimpleResponseModel(success: false, message: e.toString());
    }
  }

  // Get products by category
  Future<SimpleResponseModel> getProductsByCategory(String category) async {
    try {
      final response = await _supabaseService.client
          .from('products')
          .select()
          .eq('category', category);

      return SimpleResponseModel(
        success: true,
        message: 'Products fetched successfully',
        data: response,
      );
    } catch (e) {
      return SimpleResponseModel(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Search products
  Future<SimpleResponseModel> searchProducts(String query) async {
    try {
      final response = await _supabaseService.client
          .from('products')
          .select()
          .ilike('name', '%$query%');

      return SimpleResponseModel(
        success: true,
        message: 'Search results fetched',
        data: response,
      );
    } catch (e) {
      return SimpleResponseModel(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Sync local products with Supabase
  Future<void> syncProductsWithSupabase(List<ProductModel> products) async {
    for (final product in products) {
      await _supabaseService.insertData('products', product.toJson());
    }
  }
}

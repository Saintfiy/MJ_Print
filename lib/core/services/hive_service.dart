import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'dart:developer';
import 'package:mj_print/core/models/cart_item_model.dart';
import 'package:mj_print/core/models/product_model.dart';

class HiveService extends GetxService {
  Box<dynamic>? _settingsBox;
  Box<dynamic>? _cartBox;
  Box<dynamic>? _productsBox;

  // ✅ GETTER DENGAN FALLBACK KE DEFAULT VALUE
  Box<dynamic> get settingsBox {
    return _settingsBox ?? _createDefaultBox('settings');
  }

  Box<dynamic> get cartBox {
    return _cartBox ?? _createDefaultBox('cart');
  }

  Box<dynamic> get productsBox {
    return _productsBox ?? _createDefaultBox('products');
  }

  // ✅ CREATE DEFAULT BOX JIKA BELUM DI-INIT
  Box<dynamic> _createDefaultBox(String name) {
    log('Warning: $name box not initialized, using memory box');
    // Return a simple in-memory box as fallback
    return Hive.box(name); // This will use the already opened box
  }

  final RxBool isDarkMode = false.obs;
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final RxBool isInitialized = false.obs;

  Future<HiveService> init() async {
    try {
      await initializeHive();
      await loadSettings();
      await loadCartItems();
      isInitialized.value = true;
      log('HiveService initialized successfully');
    } catch (e) {
      log('Error initializing HiveService: $e');
    }
    return this;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await init();
  }

  Future<void> initializeHive() async {
    try {
      _settingsBox = await Hive.openBox('settings');
      _cartBox = await Hive.openBox('cart');
      _productsBox = await Hive.openBox('products');
      log('Hive boxes opened successfully');
    } catch (e) {
      log('Error opening Hive boxes: $e');
    }
  }

  // Settings Methods dengan null safety
  Future<void> loadSettings() async {
    try {
      isDarkMode.value =
          settingsBox.get('isDarkMode', defaultValue: false) ?? false;
    } catch (e) {
      log('Error loading settings: $e');
      isDarkMode.value = false;
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    isDarkMode.value = isDark;
    try {
      await settingsBox.put('isDarkMode', isDark);
    } catch (e) {
      log('Error saving theme: $e');
    }
  }

  Future<void> saveSetting(String key, dynamic value) async {
    try {
      await settingsBox.put(key, value);
    } catch (e) {
      log('Error saving setting $key: $e');
    }
  }

  dynamic getSetting(String key, {dynamic defaultValue}) {
    try {
      return settingsBox.get(key, defaultValue: defaultValue);
    } catch (e) {
      log('Error getting setting $key: $e');
      return defaultValue;
    }
  }

  // Cart Methods dengan null safety
  Future<void> loadCartItems() async {
    try {
      final cartData = cartBox.get('cartItems', defaultValue: []);
      if (cartData is List) {
        cartItems.assignAll(
          cartData.map((item) => CartItemModel.fromJson(item)).toList(),
        );
      }
    } catch (e) {
      log('Error loading cart items: $e');
      cartItems.clear();
    }
  }

  Future<void> saveCartItems() async {
    try {
      final cartData = cartItems.map((item) => item.toJson()).toList();
      await cartBox.put('cartItems', cartData);
    } catch (e) {
      log('Error saving cart items: $e');
    }
  }

  // ... (sisanya sama seperti sebelumnya, tambahkan try-catch)
  Future<void> addToCart(CartItemModel item) async {
    cartItems.add(item);
    await saveCartItems();
  }

  Future<void> removeFromCart(String itemId) async {
    cartItems.removeWhere((item) => item.id == itemId);
    await saveCartItems();
  }

  Future<void> updateCartItem(String itemId, CartItemModel updatedItem) async {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      cartItems[index] = updatedItem;
      await saveCartItems();
    }
  }

  Future<void> clearCart() async {
    cartItems.clear();
    await saveCartItems();
  }

  double get cartTotal {
    return cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get cartItemCount {
    return cartItems.length;
  }

  // Products Methods
  Future<void> saveProducts(List<ProductModel> products) async {
    try {
      final productsData = products.map((product) => product.toJson()).toList();
      await productsBox.put('products', productsData);
    } catch (e) {
      log('Error saving products: $e');
    }
  }

  Future<List<ProductModel>> getProducts() async {
    try {
      final productsData = productsBox.get('products', defaultValue: []);
      if (productsData is List) {
        return productsData.map((item) => ProductModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      log('Error getting products: $e');
      return [];
    }
  }

  // Clear all data
  Future<void> clearAllData() async {
    try {
      await settingsBox.clear();
      await cartBox.clear();
      await productsBox.clear();
      cartItems.clear();
      isDarkMode.value = false;
    } catch (e) {
      log('Error clearing data: $e');
    }
  }
}

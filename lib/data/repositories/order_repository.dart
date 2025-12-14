import 'package:get/get.dart';
import 'package:mj_print/core/models/order_model.dart';
import 'package:mj_print/data/providers/order_provider.dart';
import 'package:mj_print/core/services/hive_service.dart';

class OrderRepository extends GetxService {
  final OrderProvider _orderProvider = Get.find();
  final HiveService _hiveService = Get.find();

  // Create new order
  Future<bool> createOrder(OrderModel order) async {
    try {
      final response = await _orderProvider.createOrder(order);
      if (response.success) {
        // Clear cart after successful order
        await _hiveService.clearCart();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Get user orders
  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      final response = await _orderProvider.getOrdersByUserId(userId);
      if (response.success && response.data != null) {
        return (response.data as List)
            .map((item) => OrderModel.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Get order by ID
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final response = await _orderProvider.getOrderById(orderId);
      if (response.success && response.data != null) {
        return OrderModel.fromJson(response.data[0]);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await _orderProvider.updateOrderStatus(orderId, status);
      return response.success;
    } catch (e) {
      return false;
    }
  }

  // Cancel order
  Future<bool> cancelOrder(String orderId) async {
    try {
      final response = await _orderProvider.cancelOrder(orderId);
      return response.success;
    } catch (e) {
      return false;
    }
  }

  // Get order history with pagination
  Future<List<OrderModel>> getOrderHistory({
    String userId = '',
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _orderProvider.getOrderHistory(
        page: page,
        limit: limit,
      );
      if (response.success && response.data != null) {
        return (response.data as List)
            .map((item) => OrderModel.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Get orders by status
  Future<List<OrderModel>> getOrdersByStatus(String status) async {
    try {
      final response = await _orderProvider.getOrdersByStatus(status);
      if (response.success && response.data != null) {
        return (response.data as List)
            .map((item) => OrderModel.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Get order statistics
  Future<Map<String, dynamic>> getOrderStats(String userId) async {
    try {
      final orders = await getUserOrders(userId);

      final totalOrders = orders.length;
      final pendingOrders = orders.where((o) => o.status == 'pending').length;
      final completedOrders =
          orders.where((o) => o.status == 'completed').length;
      final totalRevenue =
          orders.fold(0.0, (sum, order) => sum + order.totalAmount);

      return {
        'totalOrders': totalOrders,
        'pendingOrders': pendingOrders,
        'completedOrders': completedOrders,
        'totalRevenue': totalRevenue,
        'averageOrderValue': totalOrders > 0 ? totalRevenue / totalOrders : 0,
      };
    } catch (e) {
      return {
        'totalOrders': 0,
        'pendingOrders': 0,
        'completedOrders': 0,
        'totalRevenue': 0,
        'averageOrderValue': 0,
      };
    }
  }

  // Stream for real-time order updates
  Stream<List<OrderModel>> get orderUpdates {
    return _orderProvider.getOrderUpdates().asyncMap((data) {
      return data.map((item) => OrderModel.fromJson(item)).toList();
    });
  }
}

import 'package:get/get.dart';
import 'package:mj_print/core/services/supabase_service.dart';
import 'package:mj_print/core/models/simple_response_model.dart';
import 'package:mj_print/core/models/order_model.dart';

class OrderProvider extends GetxService {
  final SupabaseService _supabaseService = Get.find();

  // Create new order
  Future<SimpleResponseModel> createOrder(OrderModel order) async {
    try {
      // Prepare order data with snake_case DB columns
      final orderData = {
        'user_id': order.userId,
        'customer_name': order.customerName,
        'customer_email': order.customerEmail,
        'customer_phone': order.customerPhone,
        'customer_address': order.deliveryAddress,
        'total_amount': order.totalAmount,
        'tax_amount': order.taxAmount ?? 0,
        'shipping_cost': order.shippingCost ?? 0,
        'final_amount': order.finalAmount ?? order.totalAmount,
        'status': order.status,
        'payment_method': order.paymentMethod,
        'payment_status': order.paymentStatus ?? 'unpaid',
        'notes': order.notes,
        'estimated_delivery': order.estimatedDelivery?.toIso8601String(),
      };

      final inserted = await _supabaseService.insertData('orders', orderData);
      final insertedOrder = inserted.isNotEmpty ? inserted[0] : null;

      if (insertedOrder == null) {
        return SimpleResponseModel(
            success: false, message: 'Failed to create order');
      }

      final orderId = insertedOrder['id'];

      // Insert order items
      for (final item in order.items) {
        final itemData = {
          'order_id': orderId,
          'product_id': item.product.id,
          'product_name': item.product.name,
          'quantity': item.quantity,
          'unit_price': item.product.basePrice,
          'subtotal': item.totalPrice,
          'specifications': item.toJson(),
          'notes': item.notes,
        };

        await _supabaseService.insertData('order_items', itemData);
      }

      return SimpleResponseModel(
          success: true, message: 'Order created', data: inserted);
    } catch (e) {
      return SimpleResponseModel(success: false, message: e.toString());
    }
  }

  // Get all orders
  Future<SimpleResponseModel> getOrders() async {
    try {
      final response = await _supabaseService.getData('orders');
      return SimpleResponseModel(
          success: true, message: 'Orders fetched', data: response);
    } catch (e) {
      return SimpleResponseModel(success: false, message: e.toString());
    }
  }

  // Get orders by user ID
  Future<SimpleResponseModel> getOrdersByUserId(String userId) async {
    try {
      final response = await _supabaseService.client
          .from('orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return SimpleResponseModel(
        success: true,
        message: 'Orders fetched successfully',
        data: response,
      );
    } catch (e) {
      return SimpleResponseModel(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Get order by ID
  Future<SimpleResponseModel> getOrderById(String orderId) async {
    try {
      final response =
          await _supabaseService.getData('orders', filters: {'id': orderId});
      return SimpleResponseModel(
          success: true, message: 'Order fetched', data: response);
    } catch (e) {
      return SimpleResponseModel(success: false, message: e.toString());
    }
  }

  // Update order status
  Future<SimpleResponseModel> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    try {
      final response = await _supabaseService.updateData(
        'orders',
        orderId,
        {'status': status},
      );
      return SimpleResponseModel(
          success: true, message: 'Order updated', data: response);
    } catch (e) {
      return SimpleResponseModel(success: false, message: e.toString());
    }
  }

  // Cancel order
  Future<SimpleResponseModel> cancelOrder(String orderId) async {
    return await updateOrderStatus(orderId, 'cancelled');
  }

  // Delete order
  Future<SimpleResponseModel> deleteOrder(String orderId) async {
    try {
      await _supabaseService.deleteData('orders', orderId);
      return SimpleResponseModel(success: true, message: 'Order deleted');
    } catch (e) {
      return SimpleResponseModel(success: false, message: e.toString());
    }
  }

  // Get order history with pagination
  Future<SimpleResponseModel> getOrderHistory({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final from = (page - 1) * limit;
      final to = from + limit - 1;

      final response = await _supabaseService.client
          .from('orders')
          .select()
          .range(from, to)
          .order('created_at', ascending: false);

      return SimpleResponseModel(
        success: true,
        message: 'Order history fetched',
        data: response,
      );
    } catch (e) {
      return SimpleResponseModel(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Get orders by status
  Future<SimpleResponseModel> getOrdersByStatus(String status) async {
    try {
      final response = await _supabaseService.client
          .from('orders')
          .select()
          .eq('status', status)
          .order('created_at', ascending: false);

      return SimpleResponseModel(
        success: true,
        message: 'Orders fetched by status',
        data: response,
      );
    } catch (e) {
      return SimpleResponseModel(
        success: false,
        message: e.toString(),
      );
    }
  }

  // Real-time order updates
  Stream<List<Map<String, dynamic>>> getOrderUpdates() {
    return _supabaseService.subscribeToTable('orders');
  }
}

import 'package:flutter/material.dart'; // IMPORT INI DITAMBAHKAN
import 'package:get/get.dart';
import 'package:mj_print/core/models/order_model.dart';
import 'package:mj_print/core/utils/helpers.dart';

class HistoryController extends GetxController {
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxList<OrderModel> filteredOrders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedStatus = 'Semua'.obs;

  final List<String> statusFilters = [
    'Semua',
    'pending',
    'processing',
    'shipped',
    'delivered',
    'cancelled',
  ];

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    try {
      // In a real app, you would get orders for the current user
      // For demo, we'll use mock data
      await Future.delayed(const Duration(seconds: 1));

      final mockOrders = [
        OrderModel(
          id: 'ORD-001',
          items: [],
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          status: 'delivered',
          totalAmount: 150000,
          customerName: 'Customer MJ Print',
          customerEmail: 'customer@example.com',
          customerPhone: '+6281234567890',
          deliveryAddress: 'Jl. Percetakan No. 123, Malang',
        ),
        OrderModel(
          id: 'ORD-002',
          items: [],
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          status: 'processing',
          totalAmount: 250000,
          customerName: 'Customer MJ Print',
          customerEmail: 'customer@example.com',
          customerPhone: '+6281234567890',
          deliveryAddress: 'Jl. Percetakan No. 123, Malang',
        ),
        OrderModel(
          id: 'ORD-003',
          items: [],
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          status: 'pending',
          totalAmount: 100000,
          customerName: 'Customer MJ Print',
          customerEmail: 'customer@example.com',
          customerPhone: '+6281234567890',
          deliveryAddress: 'Jl. Percetakan No. 123, Malang',
        ),
      ];

      orders.assignAll(mockOrders);
      filteredOrders.assignAll(mockOrders);
    } catch (e) {
      Helpers.showSnackbar(
        title: 'Error',
        message: 'Gagal memuat riwayat pesanan: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;

    if (status == 'Semua') {
      filteredOrders.assignAll(orders);
    } else {
      filteredOrders.assignAll(
        orders.where((order) => order.status == status).toList(),
      );
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Menunggu';
      case 'processing':
        return 'Diproses';
      case 'shipped':
        return 'Dikirim';
      case 'delivered':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void refreshOrders() async {
    await loadOrders();
    Helpers.showSnackbar(
      title: 'Success',
      message: 'Riwayat pesanan diperbarui',
    );
  }
}

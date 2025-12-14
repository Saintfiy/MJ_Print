import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'history_controller.dart';
import 'package:mj_print/core/models/order_model.dart'; // IMPORT INI DITAMBAHKAN

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshOrders,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: _buildOrderList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.statusFilters.length,
        itemBuilder: (context, index) {
          final status = controller.statusFilters[index];
          return Obx(() => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(
                    status == 'Semua'
                        ? status
                        : controller.getStatusText(status),
                  ),
                  selected: controller.selectedStatus.value == status,
                  onSelected: (selected) {
                    controller.filterByStatus(status);
                  },
                ),
              ));
        },
      ),
    );
  }

  Widget _buildOrderList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.filteredOrders.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Tidak ada riwayat pesanan',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadOrders,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.filteredOrders.length,
          itemBuilder: (context, index) {
            final order = controller.filteredOrders[index];
            return _buildOrderCard(order);
          },
        ),
      );
    });
  }

  Widget _buildOrderCard(OrderModel order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.id,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: controller.getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    controller.getStatusText(order.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${order.createdAt?.day ?? '-'} / ${order.createdAt?.month ?? '-'} / ${order.createdAt?.year ?? '-'}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.shopping_bag, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${order.items.length} items',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
            if (order.deliveryAddress != null &&
                order.deliveryAddress!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      order.deliveryAddress!,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  'Rp ${order.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

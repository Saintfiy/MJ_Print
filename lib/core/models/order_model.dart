import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final List<CartItemModel> items;
  final String? orderNumber;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String status;
  final double totalAmount;
  final double? taxAmount;
  final double? shippingCost;
  final double? finalAmount;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String? deliveryAddress;
  final String? paymentMethod;
  final String? paymentStatus;
  final String? notes;
  final DateTime? estimatedDelivery;
  final DateTime? deliveredAt;

  OrderModel({
    required this.id,
    required this.items,
    this.orderNumber,
    this.userId,
    this.createdAt,
    this.updatedAt,
    required this.status,
    required this.totalAmount,
    this.taxAmount,
    this.shippingCost,
    this.finalAmount,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    this.deliveryAddress,
    this.paymentMethod,
    this.paymentStatus,
    this.notes,
    this.estimatedDelivery,
    this.deliveredAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'order_number': orderNumber,
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'status': status,
      'total_amount': totalAmount,
      'tax_amount': taxAmount,
      'shipping_cost': shippingCost,
      'final_amount': finalAmount,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'customer_phone': customerPhone,
      'delivery_address': deliveryAddress,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'notes': notes,
      'estimated_delivery': estimatedDelivery?.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      items: List<CartItemModel>.from(
          (json['items'] ?? []).map((x) => CartItemModel.fromJson(x))),
      orderNumber: json['order_number'],
      userId: json['user_id'] ?? json['customer_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      status: json['status'] ?? 'pending',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      taxAmount: (json['tax_amount'] ?? 0).toDouble(),
      shippingCost: (json['shipping_cost'] ?? 0).toDouble(),
      finalAmount:
          (json['final_amount'] ?? json['total_amount'] ?? 0).toDouble(),
      customerName: json['customer_name'] ?? '',
      customerEmail: json['customer_email'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      deliveryAddress: json['delivery_address'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      notes: json['notes'],
      estimatedDelivery: json['estimated_delivery'] != null
          ? DateTime.parse(json['estimated_delivery'])
          : null,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'])
          : null,
    );
  }
}

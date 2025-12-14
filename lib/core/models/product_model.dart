class ProductModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final String? subcategory;
  final String? material;
  final String? size;
  final String? color;
  final int stockQuantity;
  final int minOrder;
  final String? imageUrl;
  final bool isActive;
  final double basePrice; // kept for backward-compatibility
  final String unit;
  final List<String> sizes;
  final String icon;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.price = 0.0,
    this.subcategory,
    this.material,
    this.size,
    this.color,
    this.stockQuantity = 0,
    this.minOrder = 1,
    this.imageUrl,
    this.isActive = true,
    required this.basePrice,
    required this.unit,
    required this.sizes,
    required this.icon,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'subcategory': subcategory,
      'material': material,
      'size': size,
      'color': color,
      'stock_quantity': stockQuantity,
      'min_order': minOrder,
      'image_url': imageUrl,
      'is_active': isActive,
      'basePrice': basePrice,
      'unit': unit,
      'sizes': sizes,
      'icon': icon,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? json['basePrice'] ?? 0).toDouble(),
      subcategory: json['subcategory'],
      material: json['material'],
      size: json['size'],
      color: json['color'],
      stockQuantity: (json['stock_quantity'] ?? 0) as int,
      minOrder: (json['min_order'] ?? 1) as int,
      imageUrl: json['image_url'] ?? '',
      isActive: json['is_active'] ?? true,
      basePrice: (json['basePrice'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      sizes: List<String>.from(json['sizes'] ?? []),
      icon: json['icon'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  static List<ProductModel> getProducts() {
    return [
      ProductModel(
        id: '1',
        name: 'Banner Premium',
        category: 'Banner',
        description: 'Banner dengan bahan berkualitas tinggi, tahan lama',
        basePrice: 50000,
        unit: 'per m²',
        sizes: ['1x1 m', '2x1 m', '3x1 m', '4x2 m'],
        icon: '🎯',
      ),
      ProductModel(
        id: '2',
        name: 'Kartu Nama',
        category: 'Kartu',
        description: 'Kartu nama profesional, 1 box isi 100 lembar',
        basePrice: 75000,
        unit: 'per box',
        sizes: ['Standard (9x5.5 cm)', 'Custom'],
        icon: '💳',
      ),
      ProductModel(
        id: '3',
        name: 'Brosur A4',
        category: 'Brosur',
        description: 'Brosur cetak full color, kertas art paper',
        basePrice: 150000,
        unit: 'per 100 lembar',
        sizes: ['A4', 'A5', 'A6'],
        icon: '📄',
      ),
      ProductModel(
        id: '4',
        name: 'Stiker Vinyl',
        category: 'Stiker',
        description: 'Stiker vinyl premium, tahan air dan UV',
        basePrice: 35000,
        unit: 'per lembar',
        sizes: ['A4', 'A3', 'Custom'],
        icon: '🏷️',
      ),
      ProductModel(
        id: '5',
        name: 'Kalender Meja',
        category: 'Kalender',
        description: 'Kalender meja custom design, full color',
        basePrice: 25000,
        unit: 'per pcs',
        sizes: ['Standard', 'Mini'],
        icon: '📅',
      ),
      ProductModel(
        id: '6',
        name: 'Spanduk MMT',
        category: 'Banner',
        description: 'Spanduk MMT untuk outdoor, tahan cuaca',
        basePrice: 45000,
        unit: 'per m²',
        sizes: ['2x1 m', '3x1 m', '4x2 m', '5x2 m'],
        icon: '🚩',
      ),
    ];
  }
}

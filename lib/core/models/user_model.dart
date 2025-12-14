class UserModel {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? address;
  final String? avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? role;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.address,
    this.avatar,
    this.createdAt,
    this.updatedAt,
    this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      // Map to DB column names (snake_case)
      'full_name': name,
      'phone_number': phone,
      'address': address,
      'avatar_url': avatar,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'role': role,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      // Accept either camelCase or snake_case from DB
      name: json['name'] ?? json['full_name'] ?? '',
      phone: json['phone'] ?? json['phone_number'],
      address: json['address'],
      avatar: json['avatar'] ?? json['avatar_url'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : (json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : (json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null),
      role: json['role'],
    );
  }

  factory UserModel.empty() {
    return UserModel(
      id: '',
      email: '',
      name: '',
      role: null,
    );
  }
}

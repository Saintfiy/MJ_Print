class SimpleResponseModel {
  final bool success;
  final String message;
  final dynamic data;

  SimpleResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
    };
  }

  factory SimpleResponseModel.fromJson(Map<String, dynamic> json) {
    return SimpleResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}
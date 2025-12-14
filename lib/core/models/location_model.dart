class LocationModel {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final String provider;
  final DateTime timestamp;
  final String? address;

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    required this.provider,
    required this.timestamp,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'provider': provider,
      'timestamp': timestamp.toIso8601String(),
      'address': address,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      accuracy: json['accuracy']?.toDouble(),
      provider: json['provider'] ?? 'unknown',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      address: json['address'],
    );
  }
}
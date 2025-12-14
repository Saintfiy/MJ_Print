import 'package:get/get.dart';
import 'package:mj_print/core/models/location_model.dart';
import 'package:mj_print/data/providers/location_provider.dart';
import 'package:mj_print/core/services/location_service.dart';
import 'package:mj_print/core/services/storage_service.dart';

class LocationRepository extends GetxService {
  final LocationProvider _locationProvider = Get.find();
  final LocationService _locationService = Get.find();
  final StorageService _storageService = Get.find();

  // Get current location
  Future<LocationModel?> getCurrentLocation() async {
    return await _locationService.getCurrentLocation();
  }

  // Save location to cloud
  Future<bool> saveLocationToCloud(LocationModel location) async {
    try {
      final response = await _locationProvider.saveLocation(location);
      return response.success;
    } catch (e) {
      return false;
    }
  }

  // Get location history from cloud
  Future<List<LocationModel>> getLocationHistory(String userId) async {
    try {
      final response = await _locationProvider.getLocationsByUser(userId);
      if (response.success && response.data != null) {
        return (response.data as List)
            .map((item) => LocationModel.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Start live location tracking
  void startLiveTracking() {
    _locationService.startTracking();
  }

  // Stop live location tracking
  void stopLiveTracking() {
    _locationService.stopTracking();
  }

  // Toggle location provider
  void toggleLocationProvider() {
    _locationService.toggleLocationProvider();
    _storageService
        .setLocationProvider(_locationService.locationProvider.value);
  }

  // Get current location provider
  String getCurrentProvider() {
    return _locationService.locationProvider.value;
  }

  // Check location permission
  Future<bool> checkLocationPermission() async {
    return await _locationService.checkPermission();
  }

  // Get location accuracy
  double getLocationAccuracy() {
    return _locationService.accuracy.value;
  }

  // Calculate distance between two points
  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return _locationService.calculateDistance(lat1, lon1, lat2, lon2);
  }

  // Clear location history
  Future<bool> clearLocationHistory(String userId) async {
    try {
      final response = await _locationProvider.clearLocationHistory(userId);
      return response.success;
    } catch (e) {
      return false;
    }
  }

  // Stream for live location updates
  Stream<LocationModel?> get liveLocationUpdates {
    return _locationService.liveLocationUpdates;
  }
}

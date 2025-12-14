import 'package:flutter/material.dart'; // IMPORT INI DITAMBAHKAN
import 'package:get/get.dart';
import 'package:mj_print/core/models/location_model.dart';
import 'package:mj_print/data/repositories/location_repository.dart';
import 'package:mj_print/core/utils/helpers.dart';

class LocationController extends GetxController {
  final LocationRepository _locationRepository = Get.find();

  final Rx<LocationModel?> currentLocation = Rx<LocationModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isTracking = false.obs;
  final RxString locationProvider = 'gps'.obs;
  final RxDouble accuracy = 0.0.obs;
  final RxList<LocationModel> locationHistory = <LocationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadLocationSettings();
    _setupLocationListener();
  }

  void _loadLocationSettings() {
    locationProvider.value = _locationRepository.getCurrentProvider();
  }

  void _setupLocationListener() {
    _locationRepository.liveLocationUpdates.listen((location) {
      if (location != null) {
        currentLocation.value = location;
        accuracy.value = location.accuracy ?? 0.0;
        
        // Save to history if tracking is enabled
        if (isTracking.value) {
          _saveLocationToHistory(location);
        }
      }
    });
  }

  Future<void> getCurrentLocation() async {
    isLoading.value = true;
    try {
      final hasPermission = await _locationRepository.checkLocationPermission();
      if (!hasPermission) {
        Helpers.showSnackbar(
          title: 'Error',
          message: 'Izin lokasi tidak diberikan',
          backgroundColor: Colors.red,
        );
        return;
      }

      final location = await _locationRepository.getCurrentLocation();
      if (location != null) {
        currentLocation.value = location;
        accuracy.value = location.accuracy ?? 0.0;
        
        // Save to cloud
        await _locationRepository.saveLocationToCloud(location);
        
        Helpers.showSnackbar(
          title: 'Success',
          message: 'Lokasi berhasil didapatkan',
        );
      } else {
        Helpers.showSnackbar(
          title: 'Error',
          message: 'Gagal mendapatkan lokasi',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Helpers.showSnackbar(
        title: 'Error',
        message: 'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleTracking() {
    if (isTracking.value) {
      _locationRepository.stopLiveTracking();
      isTracking.value = false;
      Helpers.showSnackbar(
        title: 'Info',
        message: 'Tracking lokasi dihentikan',
      );
    } else {
      _locationRepository.startLiveTracking();
      isTracking.value = true;
      Helpers.showSnackbar(
        title: 'Info',
        message: 'Tracking lokasi dimulai',
      );
    }
  }

  void toggleLocationProvider() {
    _locationRepository.toggleLocationProvider();
    locationProvider.value = _locationRepository.getCurrentProvider();
    
    Helpers.showSnackbar(
      title: 'Info',
      message: 'Provider diubah ke: ${locationProvider.value.toUpperCase()}',
    );
  }

  void _saveLocationToHistory(LocationModel location) {
    locationHistory.insert(0, location);
    
    // Keep only last 50 locations
    if (locationHistory.length > 50) {
      locationHistory.removeLast();
    }
  }

  Future<void> loadLocationHistory() async {
    // In a real app, you would load from cloud based on user ID
    // For demo, we'll use local history
  }

  void clearLocationHistory() {
    locationHistory.clear();
    Helpers.showSnackbar(
      title: 'Success',
      message: 'Riwayat lokasi dihapus',
    );
  }

  String getLocationProviderText() {
    return locationProvider.value == 'gps' ? 'GPS' : 'Network';
  }

  String getAccuracyText() {
    return '${accuracy.value.toStringAsFixed(1)} meter';
  }

  bool get hasLocation => currentLocation.value != null;
  
  double get latitude => currentLocation.value?.latitude ?? 0.0;
  double get longitude => currentLocation.value?.longitude ?? 0.0;
}
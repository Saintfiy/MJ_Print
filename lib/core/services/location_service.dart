import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer';
import 'package:mj_print/core/models/location_model.dart';
import 'dart:async';

class LocationService extends GetxService {
  final Rx<LocationModel?> _currentLocation = Rx<LocationModel?>(null);
  final RxBool isTracking = false.obs;
  final RxString locationProvider = 'gps'.obs;
  final RxDouble accuracy = 0.0.obs;

  final _locationStreamController =
      StreamController<LocationModel?>.broadcast();
  StreamSubscription<Position>? _positionStreamSubscription;

  LocationModel? get currentLocation => _currentLocation.value;
  Stream<LocationModel?> get liveLocationUpdates =>
      _locationStreamController.stream;

  Future<bool> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<LocationModel?> getCurrentLocation() async {
    try {
      final hasPermission = await checkPermission();
      if (!hasPermission) return null;

      Position position;
      if (locationProvider.value == 'network') {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
      } else {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      }

      final location = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        provider: locationProvider.value,
        timestamp: position.timestamp,
      );

      _currentLocation.value = location;
      accuracy.value = position.accuracy;
      _locationStreamController.add(location);

      return location;
    } catch (e) {
      log('Error getting location: $e');
      return null;
    }
  }

  void startTracking() {
    isTracking.value = true;
    _listenToLocationChanges();
  }

  void stopTracking() {
    isTracking.value = false;
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  void _listenToLocationChanges() {
    // PERBAIKAN: Gunakan locationSettings untuk geolocator v11+
    final locationSettings = LocationSettings(
      accuracy: locationProvider.value == 'network'
          ? LocationAccuracy.best
          : LocationAccuracy.high,
      distanceFilter: 10, // 10 meters
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      if (isTracking.value) {
        final location = LocationModel(
          latitude: position.latitude,
          longitude: position.longitude,
          accuracy: position.accuracy,
          provider: locationProvider.value,
          timestamp: position.timestamp,
        );
        _currentLocation.value = location;
        accuracy.value = position.accuracy;
        _locationStreamController.add(location);
      }
    });
  }

  void toggleLocationProvider() {
    locationProvider.value =
        locationProvider.value == 'gps' ? 'network' : 'gps';

    if (isTracking.value) {
      stopTracking();
      startTracking();
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  String getCurrentProvider() {
    return locationProvider.value;
  }

  Future<bool> saveLocationToCloud(LocationModel location) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }

  void startLiveTracking() {
    startTracking();
  }

  void stopLiveTracking() {
    stopTracking();
  }

  @override
  void onClose() {
    _positionStreamSubscription?.cancel();
    _locationStreamController.close();
    super.onClose();
  }
}

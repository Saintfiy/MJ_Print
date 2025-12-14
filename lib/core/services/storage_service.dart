import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static SharedPreferences? _prefs;

  // ✅ PASTIKAN INIT METHOD DIPANGGIL
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Theme
  Future<bool> setThemeMode(bool isDark) async {
    return await _prefs?.setBool('is_dark_mode', isDark) ?? false;
  }

  bool getThemeMode() {
    return _prefs?.getBool('is_dark_mode') ?? false;
  }

  // Auth Token
  Future<bool> setAuthToken(String token) async {
    return await _prefs?.setString('auth_token', token) ?? false;
  }

  String getAuthToken() {
    return _prefs?.getString('auth_token') ?? '';
  }

  Future<bool> removeAuthToken() async {
    return await _prefs?.remove('auth_token') ?? false;
  }

  // User Data
  Future<bool> setUserData(String userData) async {
    return await _prefs?.setString('user_data', userData) ?? false;
  }

  String getUserData() {
    return _prefs?.getString('user_data') ?? '';
  }

  // Location Provider
  Future<bool> setLocationProvider(String provider) async {
    return await _prefs?.setString('location_provider', provider) ?? false;
  }

  String getLocationProvider() {
    return _prefs?.getString('location_provider') ?? 'gps';
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
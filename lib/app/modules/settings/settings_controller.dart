import 'package:flutter/material.dart'; // IMPORT INI DITAMBAHKAN
import 'package:get/get.dart';
import 'package:mj_print/core/services/hive_service.dart';
import 'package:mj_print/core/utils/helpers.dart';

class SettingsController extends GetxController {
  final HiveService _hiveService = Get.find();

  final RxBool isDarkMode = false.obs;
  final RxBool notificationsEnabled = true.obs;
  final RxBool locationEnabled = true.obs;
  final RxString language = 'id'.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() {
    isDarkMode.value = _hiveService.isDarkMode.value;
    notificationsEnabled.value =
        _hiveService.getSetting('notifications', defaultValue: true);
    locationEnabled.value =
        _hiveService.getSetting('location', defaultValue: true);
    language.value = _hiveService.getSetting('language', defaultValue: 'id');
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    _hiveService.toggleTheme(value);
    // PERBAIKAN: Import ThemeMode dari material.dart
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    _hiveService.saveSetting('notifications', value);
  }

  void toggleLocation(bool value) {
    locationEnabled.value = value;
    _hiveService.saveSetting('location', value);
  }

  void changeLanguage(String newLanguage) {
    language.value = newLanguage;
    _hiveService.saveSetting('language', newLanguage);

    // In a real app, you would change the app locale here
    // Get.updateLocale(Locale(newLanguage));

    Helpers.showSnackbar(
      title: 'Success',
      message:
          'Bahasa diubah ke ${newLanguage == 'id' ? 'Indonesia' : 'English'}',
    );
  }

  void clearCache() {
    // PERBAIKAN: Gunakan Widget yang benar untuk AlertDialog
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Cache'),
        content: const Text('Yakin ingin menghapus semua cache aplikasi?'),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _performClearCache();
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _performClearCache() async {
    Helpers.showLoading(message: 'Menghapus cache...');

    await Future.delayed(const Duration(seconds: 2));

    // Clear specific data while keeping user settings
    await _hiveService.clearAllData();

    Helpers.hideLoading();

    Helpers.showSnackbar(
      title: 'Success',
      message: 'Cache berhasil dihapus',
    );

    // Reload settings
    loadSettings();
  }

  void resetSettings() {
    Get.dialog(
      AlertDialog(
        title: const Text('Reset Pengaturan'),
        content: const Text('Yakin ingin mengembalikan pengaturan ke default?'),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _performResetSettings();
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _performResetSettings() {
    // Reset to default values
    toggleDarkMode(false);
    toggleNotifications(true);
    toggleLocation(true);
    changeLanguage('id');

    Helpers.showSnackbar(
      title: 'Success',
      message: 'Pengaturan direset ke default',
    );
  }
}

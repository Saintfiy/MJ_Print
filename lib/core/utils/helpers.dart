import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math'; // IMPORT INI DITAMBAHKAN
import 'dart:async'; // IMPORT INI DITAMBAHKAN

class Helpers {
  // Show Snackbar
  static void showSnackbar({
    required String title,
    required String message,
    Color backgroundColor = Colors.green,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: duration,
      margin: const EdgeInsets.all(16), // PERBAIKAN: Tambah const
      borderRadius: 8,
    );
  }

  // Show Loading Dialog
  static void showLoading({String message = 'Loading...'}) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16), // PERBAIKAN: Tambah const
          child: Row(
            children: [
              const CircularProgressIndicator(), // PERBAIKAN: Tambah const
              const SizedBox(width: 16), // PERBAIKAN: Tambah const
              Text(message),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Hide Loading Dialog
  static void hideLoading() {
    if (Get.isDialogOpen!) Get.back();
  }

  // Format Currency
  static String formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  // Format Date
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Format DateTime
  static String formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Validate Email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Validate Phone Number
  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^[0-9]{10,13}$');
    return phoneRegex.hasMatch(phone);
  }

  // Calculate Distance between two coordinates
  static double calculateDistance(
    double lat1, 
    double lon1, 
    double lat2, 
    double lon2,
  ) {
    const double earthRadius = 6371; // in kilometers

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  // Debounce function
  static Function debounce(Function func, Duration duration) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(duration, () => func());
    };
  }

  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Get initial from name
  static String getInitials(String name) {
    List<String> names = name.split(' ');
    if (names.length > 1) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (name.isNotEmpty) {
      return name[0].toUpperCase();
    }
    return '?';
  }

  // PERBAIKAN: Safe string split untuk handle empty names
  static String getInitialsSafe(String name) {
    if (name.isEmpty) return '?';
    
    List<String> names = name.trim().split(' ');
    names.removeWhere((element) => element.isEmpty);
    
    if (names.length > 1) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return '?';
  }
}
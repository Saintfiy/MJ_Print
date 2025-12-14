import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: const Color(0xFF2196F3),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2196F3),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF2196F3),
    ),
    // PERBAIKAN: Gunakan TextTheme properties yang baru
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
    ),
    // PERBAIKAN: Gunakan colorScheme untuk semua colors
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
      backgroundColor: Colors.white,
    ).copyWith(
      surface: Colors.white, // Untuk dialog background
    ),
  );

  static final darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: const Color(0xFF2196F3),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF2196F3),
    ),
    // PERBAIKAN: Gunakan TextTheme properties yang baru
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white60,
      ),
    ),
    cardColor: const Color(0xFF1E1E1E),
    // PERBAIKAN: Hapus dialogTheme yang deprecated, gunakan colorScheme
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
      backgroundColor: const Color(0xFF121212),
    ).copyWith(
      surface: const Color(0xFF1E1E1E), // Untuk dialog background
    ),
  );
}
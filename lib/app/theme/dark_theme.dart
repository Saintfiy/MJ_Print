import 'package:flutter/material.dart';

class DarkTheme {
  static ThemeData get theme {
    return ThemeData.dark().copyWith(
      primaryColor: Color(0xFF2196F3),
      scaffoldBackgroundColor: Color(0xFF121212),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 0,
      ),
      cardColor: Color(0xFF1E1E1E),
      dialogBackgroundColor: Color(0xFF1E1E1E),
    );
  }
}
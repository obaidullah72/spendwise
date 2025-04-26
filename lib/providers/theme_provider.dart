import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  static ThemeData get lightTheme => ThemeData(
    primaryColor: const Color(0xFF1A237E), // Navy Blue
    scaffoldBackgroundColor: const Color(0xFFF5F7FA), // Light Gray
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF1A237E),
      secondary: Colors.white,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Color(0xFF1A237E),
      onSurface: Color(0xFF1A237E),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A237E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF1A237E)),
      bodyMedium: TextStyle(color: Color(0xFF1A237E)),
      labelLarge: TextStyle(color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    primaryColor: const Color(0xFF1A237E), // Navy Blue
    scaffoldBackgroundColor: const Color(0xFF121212), // Dark Background
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF1A237E),
      secondary: Color(0xFFBBDEFB), // Light Blue
      surface: Color(0xFF1E1E1E),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A237E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFBBDEFB),
        foregroundColor: const Color(0xFF1A237E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      labelLarge: TextStyle(color: Color(0xFF1A237E)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

import 'package:flutter/material.dart';

class AppTheme {
  // Neon colors for dark theme
  static const Color neonBlue = Color(0xFF00FFFF);
  static const Color electricBlue = Color(0xFF007FFF);
  static const Color neonPurple = Color(0xFF9D00FF);
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF1A1A1A);
  
  // Light theme colors
  static const Color lightBackground = Color(0xFF87CEEB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color primaryBlue = Color(0xFF1e3a8a);
  static const Color navyBlue = Color(0xFF1e3a8a);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: lightBackground,
      cardColor: lightSurface,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.cyan,
      scaffoldBackgroundColor: darkBackground,
      cardColor: darkSurface,
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: neonBlue,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: neonBlue,
        unselectedItemColor: Colors.grey,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
        titleLarge: TextStyle(color: neonBlue),
      ),
    );
  }
}

class AppColors {
  static const Color navyBlue = Color(0xFF1e3a8a);
  static const Color neonBlue = Color(0xFF00FFFF);
  static const Color skyBlue = Color(0xFF87CEEB);
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeData get currentTheme => _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
  
  // Color getters for easy access
  Color get backgroundColor => _isDarkMode ? AppTheme.darkBackground : AppTheme.lightBackground;
  Color get surfaceColor => _isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface;
  Color get primaryColor => _isDarkMode ? AppTheme.neonBlue : AppTheme.primaryBlue;
  Color get cardBackgroundColor => _isDarkMode ? AppTheme.darkSurface : Colors.white;
  Color get appBarBackgroundColor => _isDarkMode ? AppTheme.darkBackground : AppTheme.primaryBlue;
  Color get bottomNavBackgroundColor => _isDarkMode ? AppTheme.darkSurface : Colors.white;
  Color get textColor => _isDarkMode ? Colors.white : Colors.black87;
  Color get textSecondaryColor => _isDarkMode ? Colors.white70 : Colors.grey[600]!;
  Color get iconColor => _isDarkMode ? Colors.grey : Colors.grey[600]!;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

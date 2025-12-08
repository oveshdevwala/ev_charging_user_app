/// File: lib/admin/core/theme/admin_theme.dart
/// Purpose: Main admin theme wrapper and utilities
/// Belongs To: admin/core/theme
/// Customization Guide:
///    - Use AdminTheme.light and AdminTheme.dark for themes
///    - Access current theme mode via AdminThemeService
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_light_theme.dart';
import 'admin_dark_theme.dart';

/// Admin theme wrapper providing easy access to light/dark themes.
abstract final class AdminTheme {
  /// Light theme for admin panel.
  static ThemeData get light => adminLightTheme();

  /// Dark theme for admin panel.
  static ThemeData get dark => adminDarkTheme();
}

/// Theme mode notifier for managing admin panel theme state.
class AdminThemeService extends ChangeNotifier {
  AdminThemeService() {
    _loadThemeMode();
  }

  static const String _themeModeKey = 'admin_theme_mode';
  
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  bool get isLightMode => _themeMode == ThemeMode.light;
  
  bool get isSystemMode => _themeMode == ThemeMode.system;

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeIndex = prefs.getInt(_themeModeKey) ?? ThemeMode.system.index;
      _themeMode = ThemeMode.values[modeIndex];
      notifyListeners();
    } catch (e) {
      // Fallback to system mode if loading fails
      _themeMode = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, mode.index);
    } catch (e) {
      // Silently fail if saving fails
    }
  }

  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }

  Future<void> setLightMode() async => setThemeMode(ThemeMode.light);
  
  Future<void> setDarkMode() async => setThemeMode(ThemeMode.dark);
  
  Future<void> setSystemMode() async => setThemeMode(ThemeMode.system);
}


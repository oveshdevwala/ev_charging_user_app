/// File: lib/core/theme/theme_manager.dart
/// Purpose: Manages theme switching and persistence
/// Belongs To: shared
/// Customization Guide:
///    - Handles theme mode switching
///    - Persists theme preference to SharedPreferences
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

/// Manages theme switching and persistence.
/// Use with ChangeNotifierProvider for reactive theme updates.
class ThemeManager extends ChangeNotifier {
  ThemeManager({SharedPreferences? prefs}) : _prefs = prefs {
    _loadThemeMode();
  }

  final SharedPreferences? _prefs;
  ThemeMode _themeMode = ThemeMode.system;

  /// Current theme mode.
  ThemeMode get themeMode => _themeMode;

  /// Whether dark mode is active.
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Whether light mode is active.
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// Whether system mode is active.
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// Loads theme mode from storage.
  Future<void> _loadThemeMode() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(AppConstants.keyThemeMode) ?? 0;
    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners();
  }

  /// Sets the theme mode and persists it.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) {
      return;
    }

    _themeMode = mode;
    notifyListeners();

    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.keyThemeMode, mode.index);
  }

  /// Sets to light mode.
  Future<void> setLightMode() => setThemeMode(ThemeMode.light);

  /// Sets to dark mode.
  Future<void> setDarkMode() => setThemeMode(ThemeMode.dark);

  /// Sets to system mode.
  Future<void> setSystemMode() => setThemeMode(ThemeMode.system);

  /// Toggles between light and dark mode.
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      await setLightMode();
    } else {
      await setDarkMode();
    }
  }
}

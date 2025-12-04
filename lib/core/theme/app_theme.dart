/// File: lib/core/theme/app_theme.dart
/// Purpose: Main theme wrapper providing light and dark themes
/// Belongs To: shared
/// Customization Guide:
///    - Import this file to access themes
///    - Use AppTheme.light or AppTheme.dark
library;

import 'package:flutter/material.dart';

import 'dark_theme.dart';
import 'light_theme.dart';

/// Main theme wrapper for the EV Charging app.
/// Provides easy access to light and dark themes.
abstract final class AppTheme {
  /// Light theme configuration.
  static ThemeData get light => LightTheme.theme;

  /// Dark theme configuration.
  static ThemeData get dark => DarkTheme.theme;

  /// Returns theme based on brightness.
  static ThemeData fromBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? dark : light;
  }
}

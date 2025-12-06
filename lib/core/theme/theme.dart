/// File: lib/core/theme/theme.dart
/// Purpose: Barrel file for all theme exports
/// Belongs To: shared
/// Customization Guide:
///    - Add new theme file exports here
///    - Note: Import app_theme_extensions.dart directly for AppColors ThemeExtension
///    - Static AppColors from app_colors.dart is exported here
library;

export 'app_colors.dart';
export 'app_text_styles.dart';
export 'app_theme.dart';
export 'color_schemes.dart';
export 'dark_theme.dart';
export 'design_tokens.dart';
export 'light_theme.dart';
export 'theme_manager.dart';

// Note: app_theme_extensions.dart is not exported to avoid name conflict
// Import it directly: import 'package:ev_charging_user_app/core/theme/app_theme_extensions.dart';

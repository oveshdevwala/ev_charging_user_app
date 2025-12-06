/// File: lib/core/theme/design_tokens.dart
/// Purpose: Semantic design tokens for the entire application
/// Belongs To: shared
/// Customization Guide:
///    - These are base design tokens (semantic meanings)
///    - Actual color values are defined in color_schemes.dart
///    - Use these tokens via context.appColors extension
library;

/// Design tokens for semantic color meanings.
/// These tokens represent the semantic purpose of colors, not specific values.
/// Actual color values are provided by AppColors ThemeExtension in color_schemes.dart.
abstract final class AppTokens {
  // ============ Semantic Token Names ============
  // These are documentation-only. Actual values come from AppColors extension.

  /// Background color for the entire app (scaffold background).
  static const String background = 'background';

  /// Surface color for cards, sheets, dialogs.
  static const String surface = 'surface';

  /// Primary text color (headings, important text).
  static const String textPrimary = 'textPrimary';

  /// Secondary text color (body text, descriptions).
  static const String textSecondary = 'textSecondary';

  /// Tertiary text color (hints, placeholders).
  static const String textTertiary = 'textTertiary';

  /// Disabled text color.
  static const String textDisabled = 'textDisabled';

  /// Primary brand color (main actions, buttons).
  static const String primary = 'primary';

  /// Secondary brand color (accent actions).
  static const String secondary = 'secondary';

  /// Success state color (success messages, confirmations).
  static const String success = 'success';

  /// Error/danger state color (errors, warnings).
  static const String danger = 'danger';

  /// Warning state color (warnings, cautions).
  static const String warning = 'warning';

  /// Info state color (informational messages).
  static const String info = 'info';

  /// Outline color for borders, dividers.
  static const String outline = 'outline';

  /// Surface variant color (elevated surfaces, input fields).
  static const String surfaceVariant = 'surfaceVariant';
}


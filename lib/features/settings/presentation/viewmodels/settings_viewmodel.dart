/// File: lib/features/settings/presentation/viewmodels/settings_viewmodel.dart
/// Purpose: Settings ViewModel for presentation logic
/// Belongs To: settings feature
/// Customization Guide:
///    - Add computed properties as needed
///    - Add validation helpers
library;

import '../../data/models/models.dart';

/// Settings ViewModel for presentation logic.
class SettingsViewModel {
  SettingsViewModel(this.settings);

  final SettingsModel settings;

  // ============================================================
  // APPEARANCE HELPERS
  // ============================================================

  /// Get readable theme mode label.
  String getThemeModeLabel(ThemeModeOption mode) {
    switch (mode) {
      case ThemeModeOption.system:
        return 'System';
      case ThemeModeOption.light:
        return 'Light';
      case ThemeModeOption.dark:
        return 'Dark';
    }
  }

  /// Get readable font size label.
  String getFontSizeLabel(FontSizeOption fontSize) {
    switch (fontSize) {
      case FontSizeOption.small:
        return 'Small';
      case FontSizeOption.medium:
        return 'Medium';
      case FontSizeOption.large:
        return 'Large';
    }
  }

  /// Get font scale multiplier.
  double getFontScaleMultiplier() {
    switch (settings.appearance.fontScale) {
      case FontSizeOption.small:
        return 0.9;
      case FontSizeOption.medium:
        return 1.0;
      case FontSizeOption.large:
        return 1.1;
    }
  }

  // ============================================================
  // NOTIFICATION HELPERS
  // ============================================================

  /// Check if quiet hours are configured.
  bool get hasQuietHours =>
      settings.notifications.quietHoursStart != null &&
      settings.notifications.quietHoursEnd != null;

  /// Get quiet hours display string.
  String get quietHoursDisplay {
    if (!hasQuietHours) {
      return 'Not set';
    }
    return '${settings.notifications.quietHoursStart} - ${settings.notifications.quietHoursEnd}';
  }

  // ============================================================
  // SECURITY HELPERS
  // ============================================================

  /// Check if PIN is set.
  bool get hasPin => settings.security.pinHash != null;

  /// Get session timeout display string.
  String get sessionTimeoutDisplay {
    final minutes = settings.security.sessionTimeoutMinutes;
    if (minutes < 60) {
      return '$minutes minutes';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) {
      return '$hours ${hours == 1 ? 'hour' : 'hours'}';
    }
    return '$hours h $remainingMinutes m';
  }

  // ============================================================
  // DATA HELPERS
  // ============================================================

  /// Get last export date display.
  String get lastExportDisplay {
    if (settings.data.lastExportAt == null) {
      return 'Never';
    }
    try {
      final date = DateTime.parse(settings.data.lastExportAt!);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return '${difference.inMinutes} minutes ago';
        }
        return '${difference.inHours} hours ago';
      }
      if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      }
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return 'Unknown';
    }
  }

  // ============================================================
  // ACCOUNT HELPERS
  // ============================================================

  /// Get display name or fallback.
  String get displayNameOrFallback =>
      settings.account.displayName ?? 'Not set';

  /// Get email or fallback.
  String get emailOrFallback => settings.account.email ?? 'Not set';

  /// Get connected apps count.
  int get connectedAppsCount => settings.account.connectedApps.length;
}


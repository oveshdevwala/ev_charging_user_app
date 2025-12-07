/// File: lib/features/settings/data/models/settings_model.dart
/// Purpose: Settings data models with json_serializable
/// Belongs To: settings feature
/// Customization Guide:
///    - Add new settings fields as needed
///    - Run build_runner to generate JSON serialization code
library;

import 'package:json_annotation/json_annotation.dart';

part 'settings_model.g.dart';

// ============================================================
// APPEARANCE SETTINGS
// ============================================================

/// Theme mode options.
enum ThemeModeOption { system, light, dark }

/// Font size options.
enum FontSizeOption { small, medium, large }

/// Appearance settings model.
@JsonSerializable()
class AppearanceSettings {
  const AppearanceSettings({
    this.themeMode = ThemeModeOption.system,
    this.accentColorHex,
    this.fontScale = FontSizeOption.medium,
  });

  factory AppearanceSettings.fromJson(Map<String, dynamic> json) =>
      _$AppearanceSettingsFromJson(json);

  final ThemeModeOption themeMode;
  final String? accentColorHex;
  final FontSizeOption fontScale;

  Map<String, dynamic> toJson() => _$AppearanceSettingsToJson(this);

  AppearanceSettings copyWith({
    ThemeModeOption? themeMode,
    String? accentColorHex,
    FontSizeOption? fontScale,
  }) {
    return AppearanceSettings(
      themeMode: themeMode ?? this.themeMode,
      accentColorHex: accentColorHex ?? this.accentColorHex,
      fontScale: fontScale ?? this.fontScale,
    );
  }
}

// ============================================================
// NOTIFICATION SETTINGS
// ============================================================

/// Notification settings model.
@JsonSerializable()
class NotificationSettings {
  const NotificationSettings({
    this.enabled = true,
    this.chargingAlerts = true,
    this.tripReminders = true,
    this.promotions = true,
    this.quietHoursStart,
    this.quietHoursEnd,
    this.soundEnabled = true,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);

  final bool enabled;
  final bool chargingAlerts;
  final bool tripReminders;
  final bool promotions;
  final String? quietHoursStart; // HH:mm format
  final String? quietHoursEnd; // HH:mm format
  final bool soundEnabled;

  Map<String, dynamic> toJson() => _$NotificationSettingsToJson(this);

  NotificationSettings copyWith({
    bool? enabled,
    bool? chargingAlerts,
    bool? tripReminders,
    bool? promotions,
    String? quietHoursStart,
    String? quietHoursEnd,
    bool? soundEnabled,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      chargingAlerts: chargingAlerts ?? this.chargingAlerts,
      tripReminders: tripReminders ?? this.tripReminders,
      promotions: promotions ?? this.promotions,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }
}

// ============================================================
// SECURITY SETTINGS
// ============================================================

/// Security settings model.
@JsonSerializable()
class SecuritySettings {
  const SecuritySettings({
    this.biometricsEnabled = false,
    this.pinHash,
    this.sessionTimeoutMinutes = 30,
  });

  factory SecuritySettings.fromJson(Map<String, dynamic> json) =>
      _$SecuritySettingsFromJson(json);

  final bool biometricsEnabled;
  final String? pinHash; // Hashed PIN, never store plain text
  final int sessionTimeoutMinutes;

  Map<String, dynamic> toJson() => _$SecuritySettingsToJson(this);

  SecuritySettings copyWith({
    bool? biometricsEnabled,
    String? pinHash,
    int? sessionTimeoutMinutes,
  }) {
    return SecuritySettings(
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      pinHash: pinHash ?? this.pinHash,
      sessionTimeoutMinutes:
          sessionTimeoutMinutes ?? this.sessionTimeoutMinutes,
    );
  }
}

// ============================================================
// PRIVACY SETTINGS
// ============================================================

/// Privacy settings model.
@JsonSerializable()
class PrivacySettings {
  const PrivacySettings({this.analyticsOptIn = true, this.locationUse = true});

  factory PrivacySettings.fromJson(Map<String, dynamic> json) =>
      _$PrivacySettingsFromJson(json);

  final bool analyticsOptIn;
  final bool locationUse;

  Map<String, dynamic> toJson() => _$PrivacySettingsToJson(this);

  PrivacySettings copyWith({bool? analyticsOptIn, bool? locationUse}) {
    return PrivacySettings(
      analyticsOptIn: analyticsOptIn ?? this.analyticsOptIn,
      locationUse: locationUse ?? this.locationUse,
    );
  }
}

// ============================================================
// DATA SETTINGS
// ============================================================

/// Data settings model.
@JsonSerializable()
class DataSettings {
  const DataSettings({this.lastExportAt});

  factory DataSettings.fromJson(Map<String, dynamic> json) =>
      _$DataSettingsFromJson(json);

  final String? lastExportAt; // ISO 8601 format

  Map<String, dynamic> toJson() => _$DataSettingsToJson(this);

  DataSettings copyWith({String? lastExportAt}) {
    return DataSettings(lastExportAt: lastExportAt ?? this.lastExportAt);
  }
}

// ============================================================
// CONNECTED APP
// ============================================================

/// Connected app model.
@JsonSerializable()
class ConnectedApp {
  const ConnectedApp({
    required this.id,
    required this.name,
    required this.iconUrl,
    this.connectedAt,
  });

  factory ConnectedApp.fromJson(Map<String, dynamic> json) =>
      _$ConnectedAppFromJson(json);

  final String id;
  final String name;
  final String iconUrl;
  final String? connectedAt; // ISO 8601 format

  Map<String, dynamic> toJson() => _$ConnectedAppToJson(this);

  ConnectedApp copyWith({
    String? id,
    String? name,
    String? iconUrl,
    String? connectedAt,
  }) {
    return ConnectedApp(
      id: id ?? this.id,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      connectedAt: connectedAt ?? this.connectedAt,
    );
  }
}

// ============================================================
// ACCOUNT SETTINGS
// ============================================================

/// Account settings model.
@JsonSerializable()
class AccountSettings {
  const AccountSettings({
    this.displayName,
    this.email,
    this.connectedApps = const [],
  });

  factory AccountSettings.fromJson(Map<String, dynamic> json) =>
      _$AccountSettingsFromJson(json);

  final String? displayName;
  final String? email;
  final List<ConnectedApp> connectedApps;

  Map<String, dynamic> toJson() => _$AccountSettingsToJson(this);

  AccountSettings copyWith({
    String? displayName,
    String? email,
    List<ConnectedApp>? connectedApps,
  }) {
    return AccountSettings(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      connectedApps: connectedApps ?? this.connectedApps,
    );
  }
}

// ============================================================
// LOCALE SETTINGS
// ============================================================

/// Locale settings model.
@JsonSerializable()
class LocaleSettings {
  const LocaleSettings({this.languageCode = 'en'});

  factory LocaleSettings.fromJson(Map<String, dynamic> json) =>
      _$LocaleSettingsFromJson(json);

  final String languageCode;

  Map<String, dynamic> toJson() => _$LocaleSettingsToJson(this);

  LocaleSettings copyWith({String? languageCode}) {
    return LocaleSettings(languageCode: languageCode ?? this.languageCode);
  }
}

// ============================================================
// ACCESSIBILITY SETTINGS
// ============================================================

/// Accessibility settings model.
@JsonSerializable()
class AccessibilitySettings {
  const AccessibilitySettings({
    this.largerText = false,
    this.highContrast = false,
    this.screenReaderHints = true,
  });

  factory AccessibilitySettings.fromJson(Map<String, dynamic> json) =>
      _$AccessibilitySettingsFromJson(json);

  final bool largerText;
  final bool highContrast;
  final bool screenReaderHints;

  Map<String, dynamic> toJson() => _$AccessibilitySettingsToJson(this);

  AccessibilitySettings copyWith({
    bool? largerText,
    bool? highContrast,
    bool? screenReaderHints,
  }) {
    return AccessibilitySettings(
      largerText: largerText ?? this.largerText,
      highContrast: highContrast ?? this.highContrast,
      screenReaderHints: screenReaderHints ?? this.screenReaderHints,
    );
  }
}

// ============================================================
// MAIN SETTINGS MODEL
// ============================================================

/// Main settings model containing all settings categories.
@JsonSerializable()
class SettingsModel {
  const SettingsModel({
    this.appearance = const AppearanceSettings(),
    this.notifications = const NotificationSettings(),
    this.security = const SecuritySettings(),
    this.privacy = const PrivacySettings(),
    this.data = const DataSettings(),
    this.account = const AccountSettings(),
    this.locale = const LocaleSettings(),
    this.accessibility = const AccessibilitySettings(),
  });

  /// Create default settings.
  factory SettingsModel.defaults() => const SettingsModel();

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  final AppearanceSettings appearance;
  final NotificationSettings notifications;
  final SecuritySettings security;
  final PrivacySettings privacy;
  final DataSettings data;
  final AccountSettings account;
  final LocaleSettings locale;
  final AccessibilitySettings accessibility;

  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);

  SettingsModel copyWith({
    AppearanceSettings? appearance,
    NotificationSettings? notifications,
    SecuritySettings? security,
    PrivacySettings? privacy,
    DataSettings? data,
    AccountSettings? account,
    LocaleSettings? locale,
    AccessibilitySettings? accessibility,
  }) {
    return SettingsModel(
      appearance: appearance ?? this.appearance,
      notifications: notifications ?? this.notifications,
      security: security ?? this.security,
      privacy: privacy ?? this.privacy,
      data: data ?? this.data,
      account: account ?? this.account,
      locale: locale ?? this.locale,
      accessibility: accessibility ?? this.accessibility,
    );
  }
}

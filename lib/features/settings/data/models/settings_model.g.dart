// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppearanceSettings _$AppearanceSettingsFromJson(Map<String, dynamic> json) =>
    AppearanceSettings(
      themeMode:
          $enumDecodeNullable(_$ThemeModeOptionEnumMap, json['themeMode']) ??
          ThemeModeOption.system,
      accentColorHex: json['accentColorHex'] as String?,
      fontScale:
          $enumDecodeNullable(_$FontSizeOptionEnumMap, json['fontScale']) ??
          FontSizeOption.medium,
    );

Map<String, dynamic> _$AppearanceSettingsToJson(AppearanceSettings instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeOptionEnumMap[instance.themeMode]!,
      'accentColorHex': instance.accentColorHex,
      'fontScale': _$FontSizeOptionEnumMap[instance.fontScale]!,
    };

const _$ThemeModeOptionEnumMap = {
  ThemeModeOption.system: 'system',
  ThemeModeOption.light: 'light',
  ThemeModeOption.dark: 'dark',
};

const _$FontSizeOptionEnumMap = {
  FontSizeOption.small: 'small',
  FontSizeOption.medium: 'medium',
  FontSizeOption.large: 'large',
};

NotificationSettings _$NotificationSettingsFromJson(
  Map<String, dynamic> json,
) => NotificationSettings(
  enabled: json['enabled'] as bool? ?? true,
  chargingAlerts: json['chargingAlerts'] as bool? ?? true,
  tripReminders: json['tripReminders'] as bool? ?? true,
  promotions: json['promotions'] as bool? ?? true,
  quietHoursStart: json['quietHoursStart'] as String?,
  quietHoursEnd: json['quietHoursEnd'] as String?,
  soundEnabled: json['soundEnabled'] as bool? ?? true,
);

Map<String, dynamic> _$NotificationSettingsToJson(
  NotificationSettings instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'chargingAlerts': instance.chargingAlerts,
  'tripReminders': instance.tripReminders,
  'promotions': instance.promotions,
  'quietHoursStart': instance.quietHoursStart,
  'quietHoursEnd': instance.quietHoursEnd,
  'soundEnabled': instance.soundEnabled,
};

SecuritySettings _$SecuritySettingsFromJson(Map<String, dynamic> json) =>
    SecuritySettings(
      biometricsEnabled: json['biometricsEnabled'] as bool? ?? false,
      pinHash: json['pinHash'] as String?,
      sessionTimeoutMinutes:
          (json['sessionTimeoutMinutes'] as num?)?.toInt() ?? 30,
    );

Map<String, dynamic> _$SecuritySettingsToJson(SecuritySettings instance) =>
    <String, dynamic>{
      'biometricsEnabled': instance.biometricsEnabled,
      'pinHash': instance.pinHash,
      'sessionTimeoutMinutes': instance.sessionTimeoutMinutes,
    };

PrivacySettings _$PrivacySettingsFromJson(Map<String, dynamic> json) =>
    PrivacySettings(
      analyticsOptIn: json['analyticsOptIn'] as bool? ?? true,
      locationUse: json['locationUse'] as bool? ?? true,
    );

Map<String, dynamic> _$PrivacySettingsToJson(PrivacySettings instance) =>
    <String, dynamic>{
      'analyticsOptIn': instance.analyticsOptIn,
      'locationUse': instance.locationUse,
    };

DataSettings _$DataSettingsFromJson(Map<String, dynamic> json) =>
    DataSettings(lastExportAt: json['lastExportAt'] as String?);

Map<String, dynamic> _$DataSettingsToJson(DataSettings instance) =>
    <String, dynamic>{'lastExportAt': instance.lastExportAt};

ConnectedApp _$ConnectedAppFromJson(Map<String, dynamic> json) => ConnectedApp(
  id: json['id'] as String,
  name: json['name'] as String,
  iconUrl: json['iconUrl'] as String,
  connectedAt: json['connectedAt'] as String?,
);

Map<String, dynamic> _$ConnectedAppToJson(ConnectedApp instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iconUrl': instance.iconUrl,
      'connectedAt': instance.connectedAt,
    };

AccountSettings _$AccountSettingsFromJson(Map<String, dynamic> json) =>
    AccountSettings(
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      connectedApps:
          (json['connectedApps'] as List<dynamic>?)
              ?.map((e) => ConnectedApp.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AccountSettingsToJson(AccountSettings instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'email': instance.email,
      'connectedApps': instance.connectedApps,
    };

LocaleSettings _$LocaleSettingsFromJson(Map<String, dynamic> json) =>
    LocaleSettings(languageCode: json['languageCode'] as String? ?? 'en');

Map<String, dynamic> _$LocaleSettingsToJson(LocaleSettings instance) =>
    <String, dynamic>{'languageCode': instance.languageCode};

AccessibilitySettings _$AccessibilitySettingsFromJson(
  Map<String, dynamic> json,
) => AccessibilitySettings(
  largerText: json['largerText'] as bool? ?? false,
  highContrast: json['highContrast'] as bool? ?? false,
  screenReaderHints: json['screenReaderHints'] as bool? ?? true,
);

Map<String, dynamic> _$AccessibilitySettingsToJson(
  AccessibilitySettings instance,
) => <String, dynamic>{
  'largerText': instance.largerText,
  'highContrast': instance.highContrast,
  'screenReaderHints': instance.screenReaderHints,
};

SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    SettingsModel(
      appearance: json['appearance'] == null
          ? const AppearanceSettings()
          : AppearanceSettings.fromJson(
              json['appearance'] as Map<String, dynamic>,
            ),
      notifications: json['notifications'] == null
          ? const NotificationSettings()
          : NotificationSettings.fromJson(
              json['notifications'] as Map<String, dynamic>,
            ),
      security: json['security'] == null
          ? const SecuritySettings()
          : SecuritySettings.fromJson(json['security'] as Map<String, dynamic>),
      privacy: json['privacy'] == null
          ? const PrivacySettings()
          : PrivacySettings.fromJson(json['privacy'] as Map<String, dynamic>),
      data: json['data'] == null
          ? const DataSettings()
          : DataSettings.fromJson(json['data'] as Map<String, dynamic>),
      account: json['account'] == null
          ? const AccountSettings()
          : AccountSettings.fromJson(json['account'] as Map<String, dynamic>),
      locale: json['locale'] == null
          ? const LocaleSettings()
          : LocaleSettings.fromJson(json['locale'] as Map<String, dynamic>),
      accessibility: json['accessibility'] == null
          ? const AccessibilitySettings()
          : AccessibilitySettings.fromJson(
              json['accessibility'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$SettingsModelToJson(SettingsModel instance) =>
    <String, dynamic>{
      'appearance': instance.appearance,
      'notifications': instance.notifications,
      'security': instance.security,
      'privacy': instance.privacy,
      'data': instance.data,
      'account': instance.account,
      'locale': instance.locale,
      'accessibility': instance.accessibility,
    };

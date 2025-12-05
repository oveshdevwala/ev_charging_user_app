// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPreferencesModel _$UserPreferencesModelFromJson(
  Map<String, dynamic> json,
) => UserPreferencesModel(
  themeMode: json['themeMode'] == null
      ? ThemeModeOption.system
      : UserPreferencesModel._themeModeFromJson(json['themeMode'] as String),
  language: json['language'] as String? ?? 'en',
  currency: json['currency'] as String? ?? 'USD',
  notifications:
      (json['notifications'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ) ??
      const {},
);

Map<String, dynamic> _$UserPreferencesModelToJson(
  UserPreferencesModel instance,
) => <String, dynamic>{
  'themeMode': UserPreferencesModel._themeModeToJson(instance.themeMode),
  'language': instance.language,
  'currency': instance.currency,
  'notifications': instance.notifications,
};

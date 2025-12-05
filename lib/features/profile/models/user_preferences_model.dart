/// File: lib/features/profile/models/user_preferences_model.dart
/// Purpose: User preferences model with JSON serialization
/// Belongs To: profile feature
/// Customization Guide:
///    - Add new preference fields as needed
///    - Run build_runner to generate JSON code
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_preferences_model.g.dart';

/// Theme mode options.
enum ThemeModeOption { system, light, dark }

/// User preferences model.
@JsonSerializable()
class UserPreferencesModel extends Equatable {
  const UserPreferencesModel({
    this.themeMode = ThemeModeOption.system,
    this.language = 'en',
    this.currency = 'USD',
    this.notifications = const {},
  });

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesModelFromJson(json);

  @JsonKey(fromJson: _themeModeFromJson, toJson: _themeModeToJson)
  final ThemeModeOption themeMode;
  final String language;
  final String currency;
  final Map<String, bool> notifications;

  Map<String, dynamic> toJson() => _$UserPreferencesModelToJson(this);

  /// Copy with new values.
  UserPreferencesModel copyWith({
    ThemeModeOption? themeMode,
    String? language,
    String? currency,
    Map<String, bool>? notifications,
  }) {
    return UserPreferencesModel(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      notifications: notifications ?? this.notifications,
    );
  }

  static ThemeModeOption _themeModeFromJson(String value) {
    return ThemeModeOption.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ThemeModeOption.system,
    );
  }

  static String _themeModeToJson(ThemeModeOption mode) => mode.name;

  @override
  List<Object?> get props => [themeMode, language, currency, notifications];
}

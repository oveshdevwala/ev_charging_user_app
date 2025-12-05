/// File: lib/features/profile/models/user_profile_model.dart
/// Purpose: User profile model with JSON serialization
/// Belongs To: profile feature
/// Customization Guide:
///    - Add new fields as needed
///    - Run build_runner to generate JSON code
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'user_preferences_model.dart';

part 'user_profile_model.g.dart';

/// User profile model.
@JsonSerializable()
class UserProfileModel extends Equatable {
  const UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.joinedAt,
    this.phone,
    this.avatarUrl,
    this.vehicleInfo = const {},
    this.preferences,
    this.bio,
    this.address,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime joinedAt;

  final Map<String, String> vehicleInfo;
  final UserPreferencesModel? preferences;
  final String? bio;
  final String? address;

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  /// Copy with new values.
  UserProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    DateTime? joinedAt,
    Map<String, String>? vehicleInfo,
    UserPreferencesModel? preferences,
    String? bio,
    String? address,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      joinedAt: joinedAt ?? this.joinedAt,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
      preferences: preferences ?? this.preferences,
      bio: bio ?? this.bio,
      address: address ?? this.address,
    );
  }

  static DateTime _dateTimeFromJson(value) {
    if (value is String) {
      return DateTime.parse(value);
    }
    return DateTime.now();
  }

  static String _dateTimeToJson(DateTime date) => date.toIso8601String();

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    avatarUrl,
    joinedAt,
    vehicleInfo,
    preferences,
    bio,
    address,
  ];
}

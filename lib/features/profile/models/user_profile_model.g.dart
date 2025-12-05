// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      joinedAt: UserProfileModel._dateTimeFromJson(json['joinedAt']),
      phone: json['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      vehicleInfo:
          (json['vehicleInfo'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      preferences: json['preferences'] == null
          ? null
          : UserPreferencesModel.fromJson(
              json['preferences'] as Map<String, dynamic>,
            ),
      bio: json['bio'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'avatarUrl': instance.avatarUrl,
      'joinedAt': UserProfileModel._dateTimeToJson(instance.joinedAt),
      'vehicleInfo': instance.vehicleInfo,
      'preferences': instance.preferences,
      'bio': instance.bio,
      'address': instance.address,
    };

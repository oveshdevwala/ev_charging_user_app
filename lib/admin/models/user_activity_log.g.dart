// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_activity_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserActivityLog _$UserActivityLogFromJson(Map<String, dynamic> json) =>
    UserActivityLog(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$ActivityLogTypeEnumMap, json['type']),
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
      ipAddress: json['ipAddress'] as String?,
      deviceInfo: json['deviceInfo'] as String?,
    );

Map<String, dynamic> _$UserActivityLogToJson(UserActivityLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$ActivityLogTypeEnumMap[instance.type]!,
      'description': instance.description,
      'timestamp': instance.timestamp.toIso8601String(),
      'metadata': instance.metadata,
      'ipAddress': instance.ipAddress,
      'deviceInfo': instance.deviceInfo,
    };

const _$ActivityLogTypeEnumMap = {
  ActivityLogType.login: 'login',
  ActivityLogType.logout: 'logout',
  ActivityLogType.passwordReset: 'password_reset',
  ActivityLogType.walletTopup: 'wallet_topup',
  ActivityLogType.chargingSession: 'charging_session',
  ActivityLogType.offerRedeemed: 'offer_redeemed',
  ActivityLogType.suspiciousActivity: 'suspicious_activity',
  ActivityLogType.profileUpdate: 'profile_update',
  ActivityLogType.vehicleAdded: 'vehicle_added',
  ActivityLogType.vehicleRemoved: 'vehicle_removed',
  ActivityLogType.other: 'other',
};

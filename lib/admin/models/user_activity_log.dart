/// File: lib/admin/models/user_activity_log.dart
/// Purpose: User activity log model for activity tracking
/// Belongs To: admin/models
/// Customization Guide:
///    - Fields can be extended as needed
///    - Run build_runner to generate user_activity_log.g.dart
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_activity_log.g.dart';

/// Activity log type enum.
enum ActivityLogType {
  @JsonValue('login')
  login,
  @JsonValue('logout')
  logout,
  @JsonValue('password_reset')
  passwordReset,
  @JsonValue('wallet_topup')
  walletTopup,
  @JsonValue('charging_session')
  chargingSession,
  @JsonValue('offer_redeemed')
  offerRedeemed,
  @JsonValue('suspicious_activity')
  suspiciousActivity,
  @JsonValue('profile_update')
  profileUpdate,
  @JsonValue('vehicle_added')
  vehicleAdded,
  @JsonValue('vehicle_removed')
  vehicleRemoved,
  @JsonValue('other')
  other,
}

/// User activity log model.
@JsonSerializable()
class UserActivityLog extends Equatable {
  const UserActivityLog({
    required this.id,
    required this.userId,
    required this.type,
    required this.description,
    required this.timestamp,
    this.metadata,
    this.ipAddress,
    this.deviceInfo,
  });

  factory UserActivityLog.fromJson(Map<String, dynamic> json) =>
      _$UserActivityLogFromJson(json);

  final String id;
  final String userId;
  final ActivityLogType type;
  final String description;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  final String? ipAddress;
  final String? deviceInfo;

  Map<String, dynamic> toJson() => _$UserActivityLogToJson(this);

  @override
  List<Object?> get props => [
    id,
    userId,
    type,
    description,
    timestamp,
    metadata,
    ipAddress,
    deviceInfo,
  ];
}

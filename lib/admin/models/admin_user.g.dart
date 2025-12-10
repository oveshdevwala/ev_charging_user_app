// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminUser _$AdminUserFromJson(Map<String, dynamic> json) => AdminUser(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  status: json['status'] as String,
  role: json['role'] as String,
  walletBalance: (json['walletBalance'] as num).toDouble(),
  totalSessions: (json['totalSessions'] as num).toInt(),
  totalSpent: (json['totalSpent'] as num).toDouble(),
  vehicleCount: (json['vehicleCount'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  phone: json['phone'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  accountType: json['accountType'] as String?,
  signupSource: json['signupSource'] as String?,
  kycStatus: json['kycStatus'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  notes: json['notes'] as String?,
  lastChargeSessionAt: json['lastChargeSessionAt'] == null
      ? null
      : DateTime.parse(json['lastChargeSessionAt'] as String),
);

Map<String, dynamic> _$AdminUserToJson(AdminUser instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'status': instance.status,
  'role': instance.role,
  'accountType': instance.accountType,
  'signupSource': instance.signupSource,
  'kycStatus': instance.kycStatus,
  'avatarUrl': instance.avatarUrl,
  'walletBalance': instance.walletBalance,
  'totalSessions': instance.totalSessions,
  'totalSpent': instance.totalSpent,
  'vehicleCount': instance.vehicleCount,
  'tags': instance.tags,
  'notes': instance.notes,
  'createdAt': instance.createdAt.toIso8601String(),
  'lastLoginAt': instance.lastLoginAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'lastChargeSessionAt': instance.lastChargeSessionAt?.toIso8601String(),
};

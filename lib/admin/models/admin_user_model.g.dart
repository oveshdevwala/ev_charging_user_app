// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminUser _$AdminUserFromJson(Map<String, dynamic> json) => AdminUser(
  id: json['id'] as String,
  email: json['email'] as String,
  status: $enumDecode(_$AdminUserStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  name: json['name'] as String?,
  phone: json['phone'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  role:
      $enumDecodeNullable(_$AdminUserRoleEnumMap, json['role']) ??
      AdminUserRole.user,
  walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0,
  totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
  totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0,
  vehicleCount: (json['vehicleCount'] as num?)?.toInt() ?? 0,
  lastLoginAt: json['lastLoginAt'] == null
      ? null
      : DateTime.parse(json['lastLoginAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$AdminUserToJson(AdminUser instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'status': _$AdminUserStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'name': instance.name,
  'phone': instance.phone,
  'avatarUrl': instance.avatarUrl,
  'role': _$AdminUserRoleEnumMap[instance.role]!,
  'walletBalance': instance.walletBalance,
  'totalSessions': instance.totalSessions,
  'totalSpent': instance.totalSpent,
  'vehicleCount': instance.vehicleCount,
  'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$AdminUserStatusEnumMap = {
  AdminUserStatus.active: 'active',
  AdminUserStatus.inactive: 'inactive',
  AdminUserStatus.suspended: 'suspended',
  AdminUserStatus.pending: 'pending',
};

const _$AdminUserRoleEnumMap = {
  AdminUserRole.user: 'user',
  AdminUserRole.premium: 'premium',
  AdminUserRole.vip: 'vip',
};

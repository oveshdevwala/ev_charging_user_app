// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_manager_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminManager _$AdminManagerFromJson(Map<String, dynamic> json) => AdminManager(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  status: $enumDecode(_$AdminManagerStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  phone: json['phone'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  assignedStations:
      (json['assignedStations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  totalStations: (json['totalStations'] as num?)?.toInt() ?? 0,
  lastLoginAt: json['lastLoginAt'] == null
      ? null
      : DateTime.parse(json['lastLoginAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$AdminManagerToJson(AdminManager instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'status': _$AdminManagerStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'phone': instance.phone,
      'avatarUrl': instance.avatarUrl,
      'assignedStations': instance.assignedStations,
      'totalStations': instance.totalStations,
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$AdminManagerStatusEnumMap = {
  AdminManagerStatus.active: 'active',
  AdminManagerStatus.inactive: 'inactive',
  AdminManagerStatus.suspended: 'suspended',
  AdminManagerStatus.pending: 'pending',
};

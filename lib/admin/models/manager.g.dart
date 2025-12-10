// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Manager _$ManagerFromJson(Map<String, dynamic> json) => Manager(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  assignedStationIds: (json['assignedStationIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
  status: json['status'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$ManagerToJson(Manager instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'assignedStationIds': instance.assignedStationIds,
  'roles': instance.roles,
  'status': instance.status,
  'createdAt': instance.createdAt.toIso8601String(),
};

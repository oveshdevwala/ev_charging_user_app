// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminLog _$AdminLogFromJson(Map<String, dynamic> json) => AdminLog(
  id: json['id'] as String,
  level: $enumDecode(_$AdminLogLevelEnumMap, json['level']),
  category: $enumDecode(_$AdminLogCategoryEnumMap, json['category']),
  message: json['message'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  userId: json['userId'] as String?,
  userName: json['userName'] as String?,
  ipAddress: json['ipAddress'] as String?,
  userAgent: json['userAgent'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
  stackTrace: json['stackTrace'] as String?,
);

Map<String, dynamic> _$AdminLogToJson(AdminLog instance) => <String, dynamic>{
  'id': instance.id,
  'level': _$AdminLogLevelEnumMap[instance.level]!,
  'category': _$AdminLogCategoryEnumMap[instance.category]!,
  'message': instance.message,
  'timestamp': instance.timestamp.toIso8601String(),
  'userId': instance.userId,
  'userName': instance.userName,
  'ipAddress': instance.ipAddress,
  'userAgent': instance.userAgent,
  'metadata': instance.metadata,
  'stackTrace': instance.stackTrace,
};

const _$AdminLogLevelEnumMap = {
  AdminLogLevel.info: 'info',
  AdminLogLevel.warning: 'warning',
  AdminLogLevel.error: 'error',
  AdminLogLevel.debug: 'debug',
};

const _$AdminLogCategoryEnumMap = {
  AdminLogCategory.auth: 'auth',
  AdminLogCategory.station: 'station',
  AdminLogCategory.user: 'user',
  AdminLogCategory.session: 'session',
  AdminLogCategory.payment: 'payment',
  AdminLogCategory.system: 'system',
  AdminLogCategory.api: 'api',
};

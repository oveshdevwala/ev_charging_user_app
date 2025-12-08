// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminSession _$AdminSessionFromJson(Map<String, dynamic> json) => AdminSession(
  id: json['id'] as String,
  userId: json['userId'] as String,
  stationId: json['stationId'] as String,
  chargerId: json['chargerId'] as String,
  status: $enumDecode(_$AdminSessionStatusEnumMap, json['status']),
  startTime: DateTime.parse(json['startTime'] as String),
  userName: json['userName'] as String?,
  stationName: json['stationName'] as String?,
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
  energyKwh: (json['energyKwh'] as num?)?.toDouble() ?? 0,
  cost: (json['cost'] as num?)?.toDouble() ?? 0,
  durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
  paymentMethod: json['paymentMethod'] as String?,
  transactionId: json['transactionId'] as String?,
);

Map<String, dynamic> _$AdminSessionToJson(AdminSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'stationId': instance.stationId,
      'chargerId': instance.chargerId,
      'status': _$AdminSessionStatusEnumMap[instance.status]!,
      'startTime': instance.startTime.toIso8601String(),
      'userName': instance.userName,
      'stationName': instance.stationName,
      'endTime': instance.endTime?.toIso8601String(),
      'energyKwh': instance.energyKwh,
      'cost': instance.cost,
      'durationMinutes': instance.durationMinutes,
      'paymentMethod': instance.paymentMethod,
      'transactionId': instance.transactionId,
    };

const _$AdminSessionStatusEnumMap = {
  AdminSessionStatus.active: 'active',
  AdminSessionStatus.completed: 'completed',
  AdminSessionStatus.cancelled: 'cancelled',
  AdminSessionStatus.failed: 'failed',
};

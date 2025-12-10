// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminSessionSummaryDto _$AdminSessionSummaryDtoFromJson(
  Map<String, dynamic> json,
) => AdminSessionSummaryDto(
  id: json['id'] as String,
  stationId: json['stationId'] as String,
  stationName: json['stationName'] as String,
  connectorId: json['connectorId'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  startAt: DateTime.parse(json['startAt'] as String),
  status: $enumDecode(_$AdminSessionStatusDtoEnumMap, json['status']),
  userAvatar: json['userAvatar'] as String?,
  vehicleModel: json['vehicleModel'] as String?,
  endAt: json['endAt'] == null ? null : DateTime.parse(json['endAt'] as String),
  durationSec: (json['durationSec'] as num?)?.toInt(),
  energyKwh: (json['energyKwh'] as num?)?.toDouble(),
  cost: (json['cost'] as num?)?.toDouble(),
  currency: json['currency'] as String?,
  paymentMethod: $enumDecodeNullable(
    _$AdminSessionPaymentMethodEnumMap,
    json['paymentMethod'],
  ),
  lastTelemetryAt: json['lastTelemetryAt'] == null
      ? null
      : DateTime.parse(json['lastTelemetryAt'] as String),
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$AdminSessionSummaryDtoToJson(
  AdminSessionSummaryDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'stationId': instance.stationId,
  'stationName': instance.stationName,
  'connectorId': instance.connectorId,
  'userId': instance.userId,
  'userName': instance.userName,
  'startAt': instance.startAt.toIso8601String(),
  'status': _$AdminSessionStatusDtoEnumMap[instance.status]!,
  'userAvatar': instance.userAvatar,
  'vehicleModel': instance.vehicleModel,
  'endAt': instance.endAt?.toIso8601String(),
  'durationSec': instance.durationSec,
  'energyKwh': instance.energyKwh,
  'cost': instance.cost,
  'currency': instance.currency,
  'paymentMethod': _$AdminSessionPaymentMethodEnumMap[instance.paymentMethod],
  'lastTelemetryAt': instance.lastTelemetryAt?.toIso8601String(),
  'tags': instance.tags,
};

const _$AdminSessionStatusDtoEnumMap = {
  AdminSessionStatusDto.active: 'active',
  AdminSessionStatusDto.completed: 'completed',
  AdminSessionStatusDto.interrupted: 'interrupted',
  AdminSessionStatusDto.cancelled: 'cancelled',
  AdminSessionStatusDto.failed: 'failed',
};

const _$AdminSessionPaymentMethodEnumMap = {
  AdminSessionPaymentMethod.wallet: 'wallet',
  AdminSessionPaymentMethod.card: 'card',
  AdminSessionPaymentMethod.cash: 'cash',
  AdminSessionPaymentMethod.invoice: 'invoice',
};

AdminSessionDetailDto _$AdminSessionDetailDtoFromJson(
  Map<String, dynamic> json,
) => AdminSessionDetailDto(
  summary: AdminSessionSummaryDto.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
  timeline: (json['timeline'] as List<dynamic>)
      .map((e) => AdminSessionEventDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  telemetry: (json['telemetry'] as List<dynamic>)
      .map((e) => AdminTelemetryPointDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  events: (json['events'] as List<dynamic>)
      .map((e) => AdminSessionEventDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  auditTrail: (json['auditTrail'] as List<dynamic>)
      .map((e) => AdminSessionEventDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  mapPolyline: (json['mapPolyline'] as List<dynamic>?)
      ?.map(
        (e) => (e as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      )
      .toList(),
  rawUrl: json['rawUrl'] as String?,
);

Map<String, dynamic> _$AdminSessionDetailDtoToJson(
  AdminSessionDetailDto instance,
) => <String, dynamic>{
  'summary': instance.summary.toJson(),
  'timeline': instance.timeline.map((e) => e.toJson()).toList(),
  'telemetry': instance.telemetry.map((e) => e.toJson()).toList(),
  'events': instance.events.map((e) => e.toJson()).toList(),
  'auditTrail': instance.auditTrail.map((e) => e.toJson()).toList(),
  'mapPolyline': instance.mapPolyline,
  'rawUrl': instance.rawUrl,
};

AdminTelemetryPointDto _$AdminTelemetryPointDtoFromJson(
  Map<String, dynamic> json,
) => AdminTelemetryPointDto(
  timestamp: DateTime.parse(json['timestamp'] as String),
  powerKw: (json['powerKw'] as num?)?.toDouble(),
  voltage: (json['voltage'] as num?)?.toDouble(),
  currentA: (json['currentA'] as num?)?.toDouble(),
  socPercent: (json['socPercent'] as num?)?.toDouble(),
  meterReading: (json['meterReading'] as num?)?.toDouble(),
);

Map<String, dynamic> _$AdminTelemetryPointDtoToJson(
  AdminTelemetryPointDto instance,
) => <String, dynamic>{
  'timestamp': instance.timestamp.toIso8601String(),
  'powerKw': instance.powerKw,
  'voltage': instance.voltage,
  'currentA': instance.currentA,
  'socPercent': instance.socPercent,
  'meterReading': instance.meterReading,
};

AdminSessionEventDto _$AdminSessionEventDtoFromJson(
  Map<String, dynamic> json,
) => AdminSessionEventDto(
  timestamp: DateTime.parse(json['timestamp'] as String),
  type: json['type'] as String,
  message: json['message'] as String,
  code: json['code'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AdminSessionEventDtoToJson(
  AdminSessionEventDto instance,
) => <String, dynamic>{
  'timestamp': instance.timestamp.toIso8601String(),
  'type': instance.type,
  'message': instance.message,
  'code': instance.code,
  'metadata': instance.metadata,
};

AdminIncidentDto _$AdminIncidentDtoFromJson(Map<String, dynamic> json) =>
    AdminIncidentDto(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      status: json['status'] as String,
      severity: json['severity'] as String,
      createdBy: json['createdBy'] as String,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$AdminIncidentDtoToJson(AdminIncidentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'status': instance.status,
      'severity': instance.severity,
      'createdBy': instance.createdBy,
      'notes': instance.notes,
    };

AdminSessionsPageDto _$AdminSessionsPageDtoFromJson(
  Map<String, dynamic> json,
) => AdminSessionsPageDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => AdminSessionSummaryDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['nextCursor'] as String?,
  hasMore: json['hasMore'] as bool? ?? false,
);

Map<String, dynamic> _$AdminSessionsPageDtoToJson(
  AdminSessionsPageDto instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'nextCursor': instance.nextCursor,
  'hasMore': instance.hasMore,
};

AdminLiveSessionEventDto _$AdminLiveSessionEventDtoFromJson(
  Map<String, dynamic> json,
) => AdminLiveSessionEventDto(
  sessionId: json['sessionId'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  type: json['type'] as String,
  payload: json['payload'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AdminLiveSessionEventDtoToJson(
  AdminLiveSessionEventDto instance,
) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'timestamp': instance.timestamp.toIso8601String(),
  'type': instance.type,
  'payload': instance.payload,
};

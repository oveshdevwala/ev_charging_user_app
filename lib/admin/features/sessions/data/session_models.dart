/// File: lib/admin/features/sessions/data/session_models.dart
/// Purpose: Data models for sessions monitoring (JSON serializable)
/// Belongs To: admin/features/sessions
/// Customization Guide:
///    - Extend models with backend fields as needed
///    - Keep DTOs lean; map to domain in repository
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session_models.g.dart';

/// Status for charging sessions.
enum AdminSessionStatusDto {
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('interrupted')
  interrupted,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('failed')
  failed,
}

/// Payment methods used for settlements.
enum AdminSessionPaymentMethod {
  @JsonValue('wallet')
  wallet,
  @JsonValue('card')
  card,
  @JsonValue('cash')
  cash,
  @JsonValue('invoice')
  invoice,
}

/// Lightweight summary used in tables.
@JsonSerializable()
class AdminSessionSummaryDto extends Equatable {
  const AdminSessionSummaryDto({
    required this.id,
    required this.stationId,
    required this.stationName,
    required this.connectorId,
    required this.userId,
    required this.userName,
    required this.startAt,
    required this.status,
    this.userAvatar,
    this.vehicleModel,
    this.endAt,
    this.durationSec,
    this.energyKwh,
    this.cost,
    this.currency,
    this.paymentMethod,
    this.lastTelemetryAt,
    this.tags = const [],
  });

  factory AdminSessionSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$AdminSessionSummaryDtoFromJson(json);

  final String id;
  final String stationId;
  final String stationName;
  final String connectorId;
  final String userId;
  final String userName;
  final DateTime startAt;
  final AdminSessionStatusDto status;
  final String? userAvatar;
  final String? vehicleModel;
  final DateTime? endAt;
  final int? durationSec;
  final double? energyKwh;
  final double? cost;
  final String? currency;
  final AdminSessionPaymentMethod? paymentMethod;
  final DateTime? lastTelemetryAt;
  final List<String> tags;

  Map<String, dynamic> toJson() => _$AdminSessionSummaryDtoToJson(this);

  AdminSessionSummaryDto copyWith({
    String? id,
    String? stationId,
    String? stationName,
    String? connectorId,
    String? userId,
    String? userName,
    DateTime? startAt,
    AdminSessionStatusDto? status,
    String? userAvatar,
    String? vehicleModel,
    DateTime? endAt,
    int? durationSec,
    double? energyKwh,
    double? cost,
    String? currency,
    AdminSessionPaymentMethod? paymentMethod,
    DateTime? lastTelemetryAt,
    List<String>? tags,
  }) {
    return AdminSessionSummaryDto(
      id: id ?? this.id,
      stationId: stationId ?? this.stationId,
      stationName: stationName ?? this.stationName,
      connectorId: connectorId ?? this.connectorId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      startAt: startAt ?? this.startAt,
      status: status ?? this.status,
      userAvatar: userAvatar ?? this.userAvatar,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      endAt: endAt ?? this.endAt,
      durationSec: durationSec ?? this.durationSec,
      energyKwh: energyKwh ?? this.energyKwh,
      cost: cost ?? this.cost,
      currency: currency ?? this.currency,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      lastTelemetryAt: lastTelemetryAt ?? this.lastTelemetryAt,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
    id,
    stationId,
    stationName,
    connectorId,
    userId,
    userName,
    startAt,
    status,
    userAvatar,
    vehicleModel,
    endAt,
    durationSec,
    energyKwh,
    cost,
    currency,
    paymentMethod,
    lastTelemetryAt,
    tags,
  ];
}

/// Detailed session payload with telemetry and events.
@JsonSerializable(explicitToJson: true)
class AdminSessionDetailDto extends Equatable {
  const AdminSessionDetailDto({
    required this.summary,
    required this.timeline,
    required this.telemetry,
    required this.events,
    required this.auditTrail,
    this.mapPolyline,
    this.rawUrl,
  });

  factory AdminSessionDetailDto.fromJson(Map<String, dynamic> json) =>
      _$AdminSessionDetailDtoFromJson(json);

  final AdminSessionSummaryDto summary;
  final List<AdminSessionEventDto> timeline;
  final List<AdminTelemetryPointDto> telemetry;
  final List<AdminSessionEventDto> events;
  final List<AdminSessionEventDto> auditTrail;
  final List<List<double>>? mapPolyline;
  final String? rawUrl;

  Map<String, dynamic> toJson() => _$AdminSessionDetailDtoToJson(this);

  AdminSessionDetailDto copyWith({
    AdminSessionSummaryDto? summary,
    List<AdminSessionEventDto>? timeline,
    List<AdminTelemetryPointDto>? telemetry,
    List<AdminSessionEventDto>? events,
    List<AdminSessionEventDto>? auditTrail,
    List<List<double>>? mapPolyline,
    String? rawUrl,
  }) {
    return AdminSessionDetailDto(
      summary: summary ?? this.summary,
      timeline: timeline ?? this.timeline,
      telemetry: telemetry ?? this.telemetry,
      events: events ?? this.events,
      auditTrail: auditTrail ?? this.auditTrail,
      mapPolyline: mapPolyline ?? this.mapPolyline,
      rawUrl: rawUrl ?? this.rawUrl,
    );
  }

  @override
  List<Object?> get props => [
    summary,
    timeline,
    telemetry,
    events,
    auditTrail,
    mapPolyline,
    rawUrl,
  ];
}

/// Single telemetry point.
@JsonSerializable()
class AdminTelemetryPointDto extends Equatable {
  const AdminTelemetryPointDto({
    required this.timestamp,
    this.powerKw,
    this.voltage,
    this.currentA,
    this.socPercent,
    this.meterReading,
  });

  factory AdminTelemetryPointDto.fromJson(Map<String, dynamic> json) =>
      _$AdminTelemetryPointDtoFromJson(json);

  final DateTime timestamp;
  final double? powerKw;
  final double? voltage;
  final double? currentA;
  final double? socPercent;
  final double? meterReading;

  Map<String, dynamic> toJson() => _$AdminTelemetryPointDtoToJson(this);

  @override
  List<Object?> get props => [
    timestamp,
    powerKw,
    voltage,
    currentA,
    socPercent,
    meterReading,
  ];
}

/// Event used in timeline, audit, and live feed.
@JsonSerializable()
class AdminSessionEventDto extends Equatable {
  const AdminSessionEventDto({
    required this.timestamp,
    required this.type,
    required this.message,
    this.code,
    this.metadata,
  });

  factory AdminSessionEventDto.fromJson(Map<String, dynamic> json) =>
      _$AdminSessionEventDtoFromJson(json);

  final DateTime timestamp;
  final String type;
  final String message;
  final String? code;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => _$AdminSessionEventDtoToJson(this);

  @override
  List<Object?> get props => [timestamp, type, message, code, metadata];
}

/// Incident payload for escalations.
@JsonSerializable()
class AdminIncidentDto extends Equatable {
  const AdminIncidentDto({
    required this.id,
    required this.sessionId,
    required this.status,
    required this.severity,
    required this.createdBy,
    this.notes,
  });

  factory AdminIncidentDto.fromJson(Map<String, dynamic> json) =>
      _$AdminIncidentDtoFromJson(json);

  final String id;
  final String sessionId;
  final String status;
  final String severity;
  final String createdBy;
  final String? notes;

  Map<String, dynamic> toJson() => _$AdminIncidentDtoToJson(this);

  @override
  List<Object?> get props => [
    id,
    sessionId,
    status,
    severity,
    createdBy,
    notes,
  ];
}

/// Paged response for cursor pagination.
@JsonSerializable(explicitToJson: true)
class AdminSessionsPageDto extends Equatable {
  const AdminSessionsPageDto({
    required this.items,
    this.nextCursor,
    this.hasMore = false,
  });

  factory AdminSessionsPageDto.fromJson(Map<String, dynamic> json) =>
      _$AdminSessionsPageDtoFromJson(json);

  final List<AdminSessionSummaryDto> items;
  final String? nextCursor;
  final bool hasMore;

  Map<String, dynamic> toJson() => _$AdminSessionsPageDtoToJson(this);

  @override
  List<Object?> get props => [items, nextCursor, hasMore];
}

/// Live event message for websocket stream.
@JsonSerializable()
class AdminLiveSessionEventDto extends Equatable {
  const AdminLiveSessionEventDto({
    required this.sessionId,
    required this.timestamp,
    required this.type,
    this.payload,
  });

  factory AdminLiveSessionEventDto.fromJson(Map<String, dynamic> json) =>
      _$AdminLiveSessionEventDtoFromJson(json);

  final String sessionId;
  final DateTime timestamp;
  final String type;
  final Map<String, dynamic>? payload;

  Map<String, dynamic> toJson() => _$AdminLiveSessionEventDtoToJson(this);

  @override
  List<Object?> get props => [sessionId, timestamp, type, payload];
}

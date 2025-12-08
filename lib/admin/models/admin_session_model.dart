/// File: lib/admin/models/admin_session_model.dart
/// Purpose: Charging session model for admin panel
/// Belongs To: admin/models
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_session_model.g.dart';

/// Session status enum.
enum AdminSessionStatus {
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('failed')
  failed,
}

/// Charging session model for admin panel.
@JsonSerializable()
class AdminSession extends Equatable {
  const AdminSession({
    required this.id,
    required this.userId,
    required this.stationId,
    required this.chargerId,
    required this.status,
    required this.startTime,
    this.userName,
    this.stationName,
    this.endTime,
    this.energyKwh = 0,
    this.cost = 0,
    this.durationMinutes = 0,
    this.paymentMethod,
    this.transactionId,
  });

  factory AdminSession.fromJson(Map<String, dynamic> json) =>
      _$AdminSessionFromJson(json);

  final String id;
  final String userId;
  final String stationId;
  final String chargerId;
  final AdminSessionStatus status;
  final DateTime startTime;
  final String? userName;
  final String? stationName;
  final DateTime? endTime;
  final double energyKwh;
  final double cost;
  final int durationMinutes;
  final String? paymentMethod;
  final String? transactionId;

  Map<String, dynamic> toJson() => _$AdminSessionToJson(this);

  /// Check if session is active.
  bool get isActive => status == AdminSessionStatus.active;

  /// Formatted duration.
  String get formattedDuration {
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  AdminSession copyWith({
    String? id,
    String? userId,
    String? stationId,
    String? chargerId,
    AdminSessionStatus? status,
    DateTime? startTime,
    String? userName,
    String? stationName,
    DateTime? endTime,
    double? energyKwh,
    double? cost,
    int? durationMinutes,
    String? paymentMethod,
    String? transactionId,
  }) {
    return AdminSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      stationId: stationId ?? this.stationId,
      chargerId: chargerId ?? this.chargerId,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      userName: userName ?? this.userName,
      stationName: stationName ?? this.stationName,
      endTime: endTime ?? this.endTime,
      energyKwh: energyKwh ?? this.energyKwh,
      cost: cost ?? this.cost,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        stationId,
        chargerId,
        status,
        startTime,
        userName,
        stationName,
        endTime,
        energyKwh,
        cost,
        durationMinutes,
        paymentMethod,
        transactionId,
      ];
}


/// File: lib/admin/models/admin_log_model.dart
/// Purpose: System log model for admin panel
/// Belongs To: admin/models
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_log_model.g.dart';

/// Log level enum.
enum AdminLogLevel {
  @JsonValue('info')
  info,
  @JsonValue('warning')
  warning,
  @JsonValue('error')
  error,
  @JsonValue('debug')
  debug,
}

/// Log category enum.
enum AdminLogCategory {
  @JsonValue('auth')
  auth,
  @JsonValue('station')
  station,
  @JsonValue('user')
  user,
  @JsonValue('session')
  session,
  @JsonValue('payment')
  payment,
  @JsonValue('system')
  system,
  @JsonValue('api')
  api,
}

/// System log model for admin panel.
@JsonSerializable()
class AdminLog extends Equatable {
  const AdminLog({
    required this.id,
    required this.level,
    required this.category,
    required this.message,
    required this.timestamp,
    this.userId,
    this.userName,
    this.ipAddress,
    this.userAgent,
    this.metadata,
    this.stackTrace,
  });

  factory AdminLog.fromJson(Map<String, dynamic> json) =>
      _$AdminLogFromJson(json);

  final String id;
  final AdminLogLevel level;
  final AdminLogCategory category;
  final String message;
  final DateTime timestamp;
  final String? userId;
  final String? userName;
  final String? ipAddress;
  final String? userAgent;
  final Map<String, dynamic>? metadata;
  final String? stackTrace;

  Map<String, dynamic> toJson() => _$AdminLogToJson(this);

  /// Check if log has error level.
  bool get isError => level == AdminLogLevel.error;

  /// Check if log has warning level.
  bool get isWarning => level == AdminLogLevel.warning;

  AdminLog copyWith({
    String? id,
    AdminLogLevel? level,
    AdminLogCategory? category,
    String? message,
    DateTime? timestamp,
    String? userId,
    String? userName,
    String? ipAddress,
    String? userAgent,
    Map<String, dynamic>? metadata,
    String? stackTrace,
  }) {
    return AdminLog(
      id: id ?? this.id,
      level: level ?? this.level,
      category: category ?? this.category,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      metadata: metadata ?? this.metadata,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }

  @override
  List<Object?> get props => [
    id,
    level,
    category,
    message,
    timestamp,
    userId,
    userName,
    ipAddress,
    userAgent,
    metadata,
    stackTrace,
  ];
}

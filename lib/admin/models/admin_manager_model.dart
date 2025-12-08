/// File: lib/admin/models/admin_manager_model.dart
/// Purpose: Station manager model for admin panel
/// Belongs To: admin/models
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_manager_model.g.dart';

/// Manager status enum.
enum AdminManagerStatus {
  @JsonValue('active')
  active,
  @JsonValue('inactive')
  inactive,
  @JsonValue('suspended')
  suspended,
  @JsonValue('pending')
  pending,
}

/// Manager model for admin panel.
@JsonSerializable()
class AdminManager extends Equatable {
  const AdminManager({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.createdAt,
    this.phone,
    this.avatarUrl,
    this.assignedStations = const [],
    this.totalStations = 0,
    this.lastLoginAt,
    this.updatedAt,
  });

  factory AdminManager.fromJson(Map<String, dynamic> json) =>
      _$AdminManagerFromJson(json);

  final String id;
  final String name;
  final String email;
  final AdminManagerStatus status;
  final DateTime createdAt;
  final String? phone;
  final String? avatarUrl;
  final List<String> assignedStations;
  final int totalStations;
  final DateTime? lastLoginAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => _$AdminManagerToJson(this);

  AdminManager copyWith({
    String? id,
    String? name,
    String? email,
    AdminManagerStatus? status,
    DateTime? createdAt,
    String? phone,
    String? avatarUrl,
    List<String>? assignedStations,
    int? totalStations,
    DateTime? lastLoginAt,
    DateTime? updatedAt,
  }) {
    return AdminManager(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      assignedStations: assignedStations ?? this.assignedStations,
      totalStations: totalStations ?? this.totalStations,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        status,
        createdAt,
        phone,
        avatarUrl,
        assignedStations,
        totalStations,
        lastLoginAt,
        updatedAt,
      ];
}


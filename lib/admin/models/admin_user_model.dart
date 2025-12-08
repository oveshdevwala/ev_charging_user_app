/// File: lib/admin/models/admin_user_model.dart
/// Purpose: User model for admin panel
/// Belongs To: admin/models
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_user_model.g.dart';

/// User status enum.
enum AdminUserStatus {
  @JsonValue('active')
  active,
  @JsonValue('inactive')
  inactive,
  @JsonValue('suspended')
  suspended,
  @JsonValue('pending')
  pending,
}

/// User role enum.
enum AdminUserRole {
  @JsonValue('user')
  user,
  @JsonValue('premium')
  premium,
  @JsonValue('vip')
  vip,
}

/// User model for admin panel.
@JsonSerializable()
class AdminUser extends Equatable {
  const AdminUser({
    required this.id,
    required this.email,
    required this.status,
    required this.createdAt,
    this.name,
    this.phone,
    this.avatarUrl,
    this.role = AdminUserRole.user,
    this.walletBalance = 0,
    this.totalSessions = 0,
    this.totalSpent = 0,
    this.vehicleCount = 0,
    this.lastLoginAt,
    this.updatedAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) =>
      _$AdminUserFromJson(json);

  final String id;
  final String email;
  final AdminUserStatus status;
  final DateTime createdAt;
  final String? name;
  final String? phone;
  final String? avatarUrl;
  final AdminUserRole role;
  final double walletBalance;
  final int totalSessions;
  final double totalSpent;
  final int vehicleCount;
  final DateTime? lastLoginAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => _$AdminUserToJson(this);

  /// Display name (name or email).
  String get displayName => name ?? email;

  AdminUser copyWith({
    String? id,
    String? email,
    AdminUserStatus? status,
    DateTime? createdAt,
    String? name,
    String? phone,
    String? avatarUrl,
    AdminUserRole? role,
    double? walletBalance,
    int? totalSessions,
    double? totalSpent,
    int? vehicleCount,
    DateTime? lastLoginAt,
    DateTime? updatedAt,
  }) {
    return AdminUser(
      id: id ?? this.id,
      email: email ?? this.email,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      walletBalance: walletBalance ?? this.walletBalance,
      totalSessions: totalSessions ?? this.totalSessions,
      totalSpent: totalSpent ?? this.totalSpent,
      vehicleCount: vehicleCount ?? this.vehicleCount,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        status,
        createdAt,
        name,
        phone,
        avatarUrl,
        role,
        walletBalance,
        totalSessions,
        totalSpent,
        vehicleCount,
        lastLoginAt,
        updatedAt,
      ];
}


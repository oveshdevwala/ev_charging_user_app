/// File: lib/admin/models/admin_user.dart
/// Purpose: Admin User model for Users Management feature
/// Belongs To: admin/models
/// Customization Guide:
///    - Fields can be extended as needed
///    - Run build_runner to generate admin_user.g.dart: flutter pub run build_runner build --delete-conflicting-outputs
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_user.g.dart';

/// Admin User model for admin panel.
@JsonSerializable()
class AdminUser extends Equatable {
  const AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.role,
    required this.walletBalance,
    required this.totalSessions,
    required this.totalSpent,
    required this.vehicleCount,
    required this.createdAt,
    required this.lastLoginAt,
    required this.updatedAt,
    this.phone,
    this.avatarUrl,
    this.accountType,
    this.signupSource,
    this.kycStatus,
    this.tags,
    this.notes,
    this.lastChargeSessionAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) =>
      _$AdminUserFromJson(json);

  final String id;
  final String name;
  final String email;
  final String? phone;
  final String status; // active, inactive, suspended, blocked
  final String role; // user, premium, vip
  final String? accountType; // personal, business
  final String? signupSource; // email, google, apple, facebook
  final String? kycStatus; // pending, verified, rejected
  final String? avatarUrl;
  final double walletBalance;
  final int totalSessions;
  final double totalSpent;
  final int vehicleCount;
  final List<String>? tags;
  final String? notes;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final DateTime updatedAt;
  final DateTime? lastChargeSessionAt;

  Map<String, dynamic> toJson() => _$AdminUserToJson(this);

  AdminUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? status,
    String? role,
    String? accountType,
    String? signupSource,
    String? kycStatus,
    String? avatarUrl,
    double? walletBalance,
    int? totalSessions,
    double? totalSpent,
    int? vehicleCount,
    List<String>? tags,
    String? notes,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    DateTime? updatedAt,
    DateTime? lastChargeSessionAt,
  }) {
    return AdminUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      role: role ?? this.role,
      accountType: accountType ?? this.accountType,
      signupSource: signupSource ?? this.signupSource,
      kycStatus: kycStatus ?? this.kycStatus,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      walletBalance: walletBalance ?? this.walletBalance,
      totalSessions: totalSessions ?? this.totalSessions,
      totalSpent: totalSpent ?? this.totalSpent,
      vehicleCount: vehicleCount ?? this.vehicleCount,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastChargeSessionAt: lastChargeSessionAt ?? this.lastChargeSessionAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        status,
        role,
        accountType,
        signupSource,
        kycStatus,
        avatarUrl,
        walletBalance,
        totalSessions,
        totalSpent,
        vehicleCount,
        tags,
        notes,
        createdAt,
        lastLoginAt,
        updatedAt,
        lastChargeSessionAt,
      ];
}


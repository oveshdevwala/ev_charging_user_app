/// File: lib/admin/models/manager.dart
/// Purpose: Manager model for Managers Management feature
/// Belongs To: admin/models
/// Customization Guide:
///    - Fields can be extended as needed
///    - Run build_runner to generate manager.g.dart: flutter pub run build_runner build --delete-conflicting-outputs
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'manager.g.dart';

/// Manager model for admin panel.
@JsonSerializable()
class Manager extends Equatable {
  const Manager({
    required this.id,
    required this.name,
    required this.email,
    required this.assignedStationIds,
    required this.roles,
    required this.status,
    required this.createdAt,
    this.phone,
  });

  factory Manager.fromJson(Map<String, dynamic> json) =>
      _$ManagerFromJson(json);

  final String id;
  final String name;
  final String email;
  final String? phone;
  final List<String> assignedStationIds;
  final List<String> roles;
  final String status;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => _$ManagerToJson(this);

  Manager copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    List<String>? assignedStationIds,
    List<String>? roles,
    String? status,
    DateTime? createdAt,
  }) {
    return Manager(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      assignedStationIds: assignedStationIds ?? this.assignedStationIds,
      roles: roles ?? this.roles,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        assignedStationIds,
        roles,
        status,
        createdAt,
      ];
}


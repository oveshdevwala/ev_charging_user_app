/// File: lib/admin/models/admin_station_model.dart
/// Purpose: Station model for admin panel
/// Belongs To: admin/models
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_station_model.g.dart';

/// Station status enum.
enum AdminStationStatus {
  @JsonValue('active')
  active,
  @JsonValue('inactive')
  inactive,
  @JsonValue('maintenance')
  maintenance,
  @JsonValue('pending')
  pending,
}

/// Charger type enum.
enum AdminChargerType {
  @JsonValue('ccs')
  ccs,
  @JsonValue('chademo')
  chademo,
  @JsonValue('type2')
  type2,
  @JsonValue('tesla')
  tesla,
  @JsonValue('j1772')
  j1772,
}

/// Charger model.
@JsonSerializable()
class AdminCharger extends Equatable {
  const AdminCharger({
    required this.id,
    required this.type,
    required this.powerKw,
    required this.status,
    this.connectorId,
    this.pricePerKwh,
  });

  factory AdminCharger.fromJson(Map<String, dynamic> json) =>
      _$AdminChargerFromJson(json);

  final String id;
  final AdminChargerType type;
  final double powerKw;
  final String status;
  final String? connectorId;
  final double? pricePerKwh;

  Map<String, dynamic> toJson() => _$AdminChargerToJson(this);

  AdminCharger copyWith({
    String? id,
    AdminChargerType? type,
    double? powerKw,
    String? status,
    String? connectorId,
    double? pricePerKwh,
  }) {
    return AdminCharger(
      id: id ?? this.id,
      type: type ?? this.type,
      powerKw: powerKw ?? this.powerKw,
      status: status ?? this.status,
      connectorId: connectorId ?? this.connectorId,
      pricePerKwh: pricePerKwh ?? this.pricePerKwh,
    );
  }

  @override
  List<Object?> get props => [id, type, powerKw, status, connectorId, pricePerKwh];
}

/// Station model for admin panel.
@JsonSerializable()
class AdminStation extends Equatable {
  const AdminStation({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
    this.description,
    this.phone,
    this.email,
    this.imageUrl,
    this.chargers = const [],
    this.amenities = const [],
    this.operatingHours,
    this.managerId,
    this.managerName,
    this.rating,
    this.totalReviews,
    this.totalSessions,
    this.totalRevenue,
    this.updatedAt,
  });

  factory AdminStation.fromJson(Map<String, dynamic> json) =>
      _$AdminStationFromJson(json);

  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final AdminStationStatus status;
  final DateTime createdAt;
  final String? description;
  final String? phone;
  final String? email;
  final String? imageUrl;
  final List<AdminCharger> chargers;
  final List<String> amenities;
  final String? operatingHours;
  final String? managerId;
  final String? managerName;
  final double? rating;
  final int? totalReviews;
  final int? totalSessions;
  final double? totalRevenue;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => _$AdminStationToJson(this);

  /// Total charger count.
  int get totalChargers => chargers.length;

  /// Available chargers count.
  int get availableChargers =>
      chargers.where((c) => c.status == 'available').length;

  /// Total power capacity.
  double get totalPowerKw =>
      chargers.fold(0, (sum, charger) => sum + charger.powerKw);

  /// Check if station has a manager.
  bool get hasManager => managerId != null && managerId!.isNotEmpty;

  AdminStation copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    AdminStationStatus? status,
    DateTime? createdAt,
    String? description,
    String? phone,
    String? email,
    String? imageUrl,
    List<AdminCharger>? chargers,
    List<String>? amenities,
    String? operatingHours,
    String? managerId,
    String? managerName,
    double? rating,
    int? totalReviews,
    int? totalSessions,
    double? totalRevenue,
    DateTime? updatedAt,
  }) {
    return AdminStation(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      chargers: chargers ?? this.chargers,
      amenities: amenities ?? this.amenities,
      operatingHours: operatingHours ?? this.operatingHours,
      managerId: managerId ?? this.managerId,
      managerName: managerName ?? this.managerName,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      totalSessions: totalSessions ?? this.totalSessions,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        latitude,
        longitude,
        status,
        createdAt,
        description,
        phone,
        email,
        imageUrl,
        chargers,
        amenities,
        operatingHours,
        managerId,
        managerName,
        rating,
        totalReviews,
        totalSessions,
        totalRevenue,
        updatedAt,
      ];
}


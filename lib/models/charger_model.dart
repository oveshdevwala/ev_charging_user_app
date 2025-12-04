/// File: lib/models/charger_model.dart
/// Purpose: Charger data model
/// Belongs To: shared
/// Customization Guide:
///    - Add new fields as needed
///    - Update copyWith and JSON methods accordingly

import 'package:equatable/equatable.dart';

/// Charger status enum.
enum ChargerStatus {
  available,
  occupied,
  charging,
  offline,
  faulted,
  reserved,
}

/// Charger connector type.
enum ChargerType {
  type1,
  type2,
  ccs,
  chademo,
  tesla,
  gb,
}

/// Charger model representing individual charging points.
class ChargerModel extends Equatable {
  const ChargerModel({
    required this.id,
    required this.stationId,
    required this.name,
    required this.type,
    this.power = 0.0,
    this.status = ChargerStatus.available,
    this.pricePerKwh,
    this.pricePerMinute,
    this.currentSessionId,
    this.lastUsed,
    this.createdAt,
    this.updatedAt,
  });
  
  final String id;
  final String stationId;
  final String name;
  final ChargerType type;
  final double power;
  final ChargerStatus status;
  final double? pricePerKwh;
  final double? pricePerMinute;
  final String? currentSessionId;
  final DateTime? lastUsed;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  /// Get charger type display name.
  String get typeDisplayName {
    switch (type) {
      case ChargerType.type1:
        return 'Type 1';
      case ChargerType.type2:
        return 'Type 2';
      case ChargerType.ccs:
        return 'CCS';
      case ChargerType.chademo:
        return 'CHAdeMO';
      case ChargerType.tesla:
        return 'Tesla';
      case ChargerType.gb:
        return 'GB/T';
    }
  }
  
  /// Get power display string.
  String get powerDisplay => '${power.toStringAsFixed(0)} kW';
  
  /// Check if charger is available.
  bool get isAvailable => status == ChargerStatus.available;
  
  /// Check if charger is in use.
  bool get isInUse => status == ChargerStatus.charging || status == ChargerStatus.occupied;
  
  /// Create from JSON map.
  factory ChargerModel.fromJson(Map<String, dynamic> json) {
    return ChargerModel(
      id: json['id'] as String? ?? '',
      stationId: json['stationId'] as String? ?? json['station_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: ChargerType.values.firstWhere(
        (t) => t.name == (json['type'] as String?),
        orElse: () => ChargerType.type2,
      ),
      power: (json['power'] as num?)?.toDouble() ?? 0.0,
      status: ChargerStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String?),
        orElse: () => ChargerStatus.available,
      ),
      pricePerKwh: (json['pricePerKwh'] as num?)?.toDouble() ?? 
                  (json['price_per_kwh'] as num?)?.toDouble(),
      pricePerMinute: (json['pricePerMinute'] as num?)?.toDouble() ??
                     (json['price_per_minute'] as num?)?.toDouble(),
      currentSessionId: json['currentSessionId'] as String? ?? 
                       json['current_session_id'] as String?,
      lastUsed: json['lastUsed'] != null 
          ? DateTime.tryParse(json['lastUsed'] as String) 
          : json['last_used'] != null
              ? DateTime.tryParse(json['last_used'] as String)
              : null,
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt'] as String) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.tryParse(json['updatedAt'] as String) 
          : null,
    );
  }
  
  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stationId': stationId,
      'name': name,
      'type': type.name,
      'power': power,
      'status': status.name,
      'pricePerKwh': pricePerKwh,
      'pricePerMinute': pricePerMinute,
      'currentSessionId': currentSessionId,
      'lastUsed': lastUsed?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
  
  /// Copy with new values.
  ChargerModel copyWith({
    String? id,
    String? stationId,
    String? name,
    ChargerType? type,
    double? power,
    ChargerStatus? status,
    double? pricePerKwh,
    double? pricePerMinute,
    String? currentSessionId,
    DateTime? lastUsed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChargerModel(
      id: id ?? this.id,
      stationId: stationId ?? this.stationId,
      name: name ?? this.name,
      type: type ?? this.type,
      power: power ?? this.power,
      status: status ?? this.status,
      pricePerKwh: pricePerKwh ?? this.pricePerKwh,
      pricePerMinute: pricePerMinute ?? this.pricePerMinute,
      currentSessionId: currentSessionId ?? this.currentSessionId,
      lastUsed: lastUsed ?? this.lastUsed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    stationId,
    name,
    type,
    power,
    status,
    pricePerKwh,
    pricePerMinute,
    currentSessionId,
    lastUsed,
    createdAt,
    updatedAt,
  ];
}


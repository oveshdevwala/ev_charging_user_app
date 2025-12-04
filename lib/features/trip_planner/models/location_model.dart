/// File: lib/features/trip_planner/models/location_model.dart
/// Purpose: Location model for trip origin, destination, and waypoints
/// Belongs To: trip_planner feature
/// Customization Guide:
///    - Add fields for place details from Maps API
///    - Extend for POI information
library;

import 'package:equatable/equatable.dart';

/// Location model representing a point on the map.
class LocationModel extends Equatable {
  const LocationModel({
    required this.latitude,
    required this.longitude,
    this.address,
    this.name,
    this.placeId,
    this.city,
    this.state,
    this.country,
    this.postalCode,
  });

  /// Create from JSON map.
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] as String?,
      name: json['name'] as String?,
      placeId: json['placeId'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      postalCode: json['postalCode'] as String?,
    );
  }

  /// Latitude coordinate.
  final double latitude;

  /// Longitude coordinate.
  final double longitude;

  /// Full formatted address.
  final String? address;

  /// Short location name.
  final String? name;

  /// Google/Maps place ID for lookup.
  final String? placeId;

  /// City name.
  final String? city;

  /// State/Province.
  final String? state;

  /// Country.
  final String? country;

  /// Postal/ZIP code.
  final String? postalCode;

  /// Get display name (name or address or coordinates).
  String get displayName {
    if (name != null && name!.isNotEmpty) {
      return name!;
    }
    if (address != null && address!.isNotEmpty) {
      return address!;
    }
    return '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
  }

  /// Get short display (city, state or first part of address).
  String get shortDisplay {
    if (city != null) {
      return state != null ? '$city, $state' : city!;
    }
    if (address != null && address!.isNotEmpty) {
      return address!.split(',').first.trim();
    }
    return displayName;
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'name': name,
      'placeId': placeId,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
    };
  }

  /// Copy with new values.
  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? name,
    String? placeId,
    String? city,
    String? state,
    String? country,
    String? postalCode,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      name: name ?? this.name,
      placeId: placeId ?? this.placeId,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        address,
        name,
        placeId,
        city,
        state,
        country,
        postalCode,
      ];
}


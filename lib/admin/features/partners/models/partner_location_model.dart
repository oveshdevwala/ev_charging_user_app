/// File: lib/admin/features/partners/models/partner_location_model.dart
/// Purpose: Partner location domain model
/// Belongs To: admin/features/partners
/// Customization Guide:
///    - Add additional location fields as needed
library;

import 'package:equatable/equatable.dart';

/// Partner location model.
class PartnerLocationModel extends Equatable {
  const PartnerLocationModel({
    required this.id,
    required this.partnerId,
    required this.label,
    required this.address,
    required this.city,
    required this.country,
    required this.lat,
    required this.lng,
    required this.createdAt,
  });

  factory PartnerLocationModel.fromJson(Map<String, dynamic> json) {
    return PartnerLocationModel(
      id: json['id'] as String? ?? '',
      partnerId: json['partnerId'] as String? ?? '',
      label: json['label'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  final String id;
  final String partnerId;
  final String label;
  final String address;
  final String city;
  final String country;
  final double lat;
  final double lng;
  final DateTime createdAt;

  /// Full address string.
  String get fullAddress => '$address, $city, $country';

  /// Coordinates string.
  String get coordinates => '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partnerId': partnerId,
      'label': label,
      'address': address,
      'city': city,
      'country': country,
      'lat': lat,
      'lng': lng,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  PartnerLocationModel copyWith({
    String? id,
    String? partnerId,
    String? label,
    String? address,
    String? city,
    String? country,
    double? lat,
    double? lng,
    DateTime? createdAt,
  }) {
    return PartnerLocationModel(
      id: id ?? this.id,
      partnerId: partnerId ?? this.partnerId,
      label: label ?? this.label,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        partnerId,
        label,
        address,
        city,
        country,
        lat,
        lng,
        createdAt,
      ];
}

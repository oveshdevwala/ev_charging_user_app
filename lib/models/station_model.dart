/// File: lib/models/station_model.dart
/// Purpose: Charging station data model
/// Belongs To: shared
/// Customization Guide:
///    - Add new fields as needed
///    - Update copyWith and JSON methods accordingly
library;

import 'package:equatable/equatable.dart';

import 'charger_model.dart';

/// Station status enum.
enum StationStatus {
  active,
  inactive,
  maintenance,
  pending,
}

/// Amenity types available at stations.
enum Amenity {
  wifi,
  restroom,
  cafe,
  restaurant,
  parking,
  shopping,
  lounge,
  playground,
}

/// Charging station model.
class StationModel extends Equatable {
  const StationModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.ownerId,
    this.description,
    this.imageUrl,
    this.images = const [],
    this.chargers = const [],
    this.amenities = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.pricePerKwh = 0.0,
    this.status = StationStatus.active,
    this.openTime,
    this.closeTime,
    this.is24Hours = false,
    this.isFavorite = false,
    this.distance,
    this.createdAt,
    this.updatedAt,
  });
  
  /// Create from JSON map.
  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      ownerId: json['ownerId'] as String? ?? json['owner_id'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String?,
      images: (json['images'] as List<dynamic>?)?.cast<String>() ?? [],
      chargers: (json['chargers'] as List<dynamic>?)
          ?.map((e) => ChargerModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => Amenity.values.firstWhere(
                (a) => a.name == e,
                orElse: () => Amenity.parking,
              ))
          .toList() ?? [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? json['review_count'] as int? ?? 0,
      pricePerKwh: (json['pricePerKwh'] as num?)?.toDouble() ?? 
                  (json['price_per_kwh'] as num?)?.toDouble() ?? 0.0,
      status: StationStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String?),
        orElse: () => StationStatus.active,
      ),
      openTime: json['openTime'] as String? ?? json['open_time'] as String?,
      closeTime: json['closeTime'] as String? ?? json['close_time'] as String?,
      is24Hours: json['is24Hours'] as bool? ?? json['is_24_hours'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? json['is_favorite'] as bool? ?? false,
      distance: (json['distance'] as num?)?.toDouble(),
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt'] as String) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.tryParse(json['updatedAt'] as String) 
          : null,
    );
  }
  
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? ownerId;
  final String? description;
  final String? imageUrl;
  final List<String> images;
  final List<ChargerModel> chargers;
  final List<Amenity> amenities;
  final double rating;
  final int reviewCount;
  final double pricePerKwh;
  final StationStatus status;
  final String? openTime;
  final String? closeTime;
  final bool is24Hours;
  final bool isFavorite;
  final double? distance;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  /// Get available chargers count.
  int get availableChargers => chargers.where((c) => c.status == ChargerStatus.available).length;
  
  /// Get total chargers count.
  int get totalChargers => chargers.length;
  
  /// Check if station has available chargers.
  bool get hasAvailableChargers => availableChargers > 0;
  
  /// Get operating hours display string.
  String get operatingHours {
    if (is24Hours) {
      return '24 Hours';
    }
    if (openTime != null && closeTime != null) {
      return '$openTime - $closeTime';
    }
    return 'Not specified';
  }
  
  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'ownerId': ownerId,
      'description': description,
      'imageUrl': imageUrl,
      'images': images,
      'chargers': chargers.map((e) => e.toJson()).toList(),
      'amenities': amenities.map((e) => e.name).toList(),
      'rating': rating,
      'reviewCount': reviewCount,
      'pricePerKwh': pricePerKwh,
      'status': status.name,
      'openTime': openTime,
      'closeTime': closeTime,
      'is24Hours': is24Hours,
      'isFavorite': isFavorite,
      'distance': distance,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
  
  /// Copy with new values.
  StationModel copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? ownerId,
    String? description,
    String? imageUrl,
    List<String>? images,
    List<ChargerModel>? chargers,
    List<Amenity>? amenities,
    double? rating,
    int? reviewCount,
    double? pricePerKwh,
    StationStatus? status,
    String? openTime,
    String? closeTime,
    bool? is24Hours,
    bool? isFavorite,
    double? distance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      ownerId: ownerId ?? this.ownerId,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      chargers: chargers ?? this.chargers,
      amenities: amenities ?? this.amenities,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      pricePerKwh: pricePerKwh ?? this.pricePerKwh,
      status: status ?? this.status,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      is24Hours: is24Hours ?? this.is24Hours,
      isFavorite: isFavorite ?? this.isFavorite,
      distance: distance ?? this.distance,
      createdAt: createdAt ?? this.createdAt,
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
    ownerId,
    description,
    imageUrl,
    images,
    chargers,
    amenities,
    rating,
    reviewCount,
    pricePerKwh,
    status,
    openTime,
    closeTime,
    is24Hours,
    isFavorite,
    distance,
    createdAt,
    updatedAt,
  ];
}


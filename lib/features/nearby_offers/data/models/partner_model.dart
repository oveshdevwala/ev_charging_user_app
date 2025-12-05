/// File: lib/features/nearby_offers/data/models/partner_model.dart
/// Purpose: Partner entity representing a business partner
/// Belongs To: nearby_offers feature
/// Customization Guide:
///    - Add new fields as needed for partner details
///    - Update toJson/fromJson for persistence
library;

import 'package:equatable/equatable.dart';

import 'partner_category.dart';

/// Partner business model.
class PartnerModel extends Equatable {
  const PartnerModel({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.description,
    this.imageUrl,
    this.logoUrl,
    this.photos = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.distance,
    this.openTime,
    this.closeTime,
    this.is24Hours = false,
    this.phone,
    this.website,
    this.activeOfferCount = 0,
    this.isFeatured = false,
    this.isVerified = false,
    this.checkInCredits = 10,
    this.checkInRadiusMeters = 100,
    this.maxCheckInsPerDay = 1,
  });

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    return PartnerModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: PartnerCategory.values.firstWhere(
        (c) => c.name == (json['category'] as String?),
        orElse: () => PartnerCategory.services,
      ),
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      logoUrl: json['logoUrl'] as String?,
      photos:
          (json['photos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      distance: (json['distance'] as num?)?.toDouble(),
      openTime: json['openTime'] as String?,
      closeTime: json['closeTime'] as String?,
      is24Hours: json['is24Hours'] as bool? ?? false,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      activeOfferCount: json['activeOfferCount'] as int? ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
      checkInCredits: json['checkInCredits'] as int? ?? 10,
      checkInRadiusMeters: json['checkInRadiusMeters'] as int? ?? 100,
      maxCheckInsPerDay: json['maxCheckInsPerDay'] as int? ?? 1,
    );
  }

  final String id;
  final String name;
  final PartnerCategory category;
  final String address;
  final double latitude;
  final double longitude;
  final String? description;
  final String? imageUrl;
  final String? logoUrl;
  final List<String> photos;
  final double rating;
  final int reviewCount;
  final double? distance;
  final String? openTime;
  final String? closeTime;
  final bool is24Hours;
  final String? phone;
  final String? website;
  final int activeOfferCount;
  final bool isFeatured;
  final bool isVerified;
  final int checkInCredits;
  final int checkInRadiusMeters;
  final int maxCheckInsPerDay;

  /// Check if partner is currently open.
  bool get isOpen {
    if (is24Hours) return true;
    if (openTime == null || closeTime == null) return true;

    final now = DateTime.now();
    final openParts = openTime!.split(':');
    final closeParts = closeTime!.split(':');

    final openDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(openParts[0]),
      int.parse(openParts[1]),
    );

    final closeDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(closeParts[0]),
      int.parse(closeParts[1]),
    );

    return now.isAfter(openDateTime) && now.isBefore(closeDateTime);
  }

  /// Get formatted operating hours.
  String get operatingHours {
    if (is24Hours) return '24 Hours';
    if (openTime == null || closeTime == null) return 'Hours not available';
    return '$openTime - $closeTime';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'imageUrl': imageUrl,
      'logoUrl': logoUrl,
      'photos': photos,
      'rating': rating,
      'reviewCount': reviewCount,
      'distance': distance,
      'openTime': openTime,
      'closeTime': closeTime,
      'is24Hours': is24Hours,
      'phone': phone,
      'website': website,
      'activeOfferCount': activeOfferCount,
      'isFeatured': isFeatured,
      'isVerified': isVerified,
      'checkInCredits': checkInCredits,
      'checkInRadiusMeters': checkInRadiusMeters,
      'maxCheckInsPerDay': maxCheckInsPerDay,
    };
  }

  PartnerModel copyWith({
    String? id,
    String? name,
    PartnerCategory? category,
    String? address,
    double? latitude,
    double? longitude,
    String? description,
    String? imageUrl,
    String? logoUrl,
    List<String>? photos,
    double? rating,
    int? reviewCount,
    double? distance,
    String? openTime,
    String? closeTime,
    bool? is24Hours,
    String? phone,
    String? website,
    int? activeOfferCount,
    bool? isFeatured,
    bool? isVerified,
    int? checkInCredits,
    int? checkInRadiusMeters,
    int? maxCheckInsPerDay,
  }) {
    return PartnerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      logoUrl: logoUrl ?? this.logoUrl,
      photos: photos ?? this.photos,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      distance: distance ?? this.distance,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      is24Hours: is24Hours ?? this.is24Hours,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      activeOfferCount: activeOfferCount ?? this.activeOfferCount,
      isFeatured: isFeatured ?? this.isFeatured,
      isVerified: isVerified ?? this.isVerified,
      checkInCredits: checkInCredits ?? this.checkInCredits,
      checkInRadiusMeters: checkInRadiusMeters ?? this.checkInRadiusMeters,
      maxCheckInsPerDay: maxCheckInsPerDay ?? this.maxCheckInsPerDay,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    address,
    latitude,
    longitude,
    description,
    imageUrl,
    logoUrl,
    photos,
    rating,
    reviewCount,
    distance,
    openTime,
    closeTime,
    is24Hours,
    phone,
    website,
    activeOfferCount,
    isFeatured,
    isVerified,
    checkInCredits,
    checkInRadiusMeters,
    maxCheckInsPerDay,
  ];
}

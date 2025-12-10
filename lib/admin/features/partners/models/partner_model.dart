/// File: lib/admin/features/partners/models/partner_model.dart
/// Purpose: Partner domain model for admin partners module
/// Belongs To: admin/features/partners
/// Customization Guide:
///    - Extend fields as backend evolves
///    - Add computed properties as needed
library;

import 'package:equatable/equatable.dart';

import 'partner_enums.dart';

/// Partner model used across list and detail surfaces.
class PartnerModel extends Equatable {
  const PartnerModel({
    required this.id,
    required this.name,
    required this.type,
    required this.email,
    required this.phone,
    required this.country,
    required this.status,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
    required this.primaryContact,
    this.logoUrl,
  });

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    return PartnerModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: partnerTypeFromString(json['type'] as String?),
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      country: json['country'] as String? ?? '',
      status: partnerStatusFromString(json['status'] as String?),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      primaryContact: json['primaryContact'] as String? ?? '',
      logoUrl: json['logoUrl'] as String?,
    );
  }

  final String id;
  final String name;
  final PartnerType type;
  final String email;
  final String phone;
  final String country;
  final PartnerStatus status;
  final double rating;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String primaryContact;
  final String? logoUrl;

  /// Formatted type name.
  String get typeName {
    switch (type) {
      case PartnerType.owner:
        return 'Owner';
      case PartnerType.operator:
        return 'Operator';
      case PartnerType.reseller:
        return 'Reseller';
    }
  }

  /// Formatted status name.
  String get statusName {
    switch (status) {
      case PartnerStatus.pending:
        return 'Pending';
      case PartnerStatus.active:
        return 'Active';
      case PartnerStatus.suspended:
        return 'Suspended';
      case PartnerStatus.rejected:
        return 'Rejected';
    }
  }

  /// Formatted rating (X.X stars).
  String get formattedRating => rating.toStringAsFixed(1);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'email': email,
      'phone': phone,
      'country': country,
      'status': status.name,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'primaryContact': primaryContact,
      'logoUrl': logoUrl,
    };
  }

  PartnerModel copyWith({
    String? id,
    String? name,
    PartnerType? type,
    String? email,
    String? phone,
    String? country,
    PartnerStatus? status,
    double? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? primaryContact,
    String? logoUrl,
  }) {
    return PartnerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      primaryContact: primaryContact ?? this.primaryContact,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        email,
        phone,
        country,
        status,
        rating,
        createdAt,
        updatedAt,
        primaryContact,
        logoUrl,
      ];
}

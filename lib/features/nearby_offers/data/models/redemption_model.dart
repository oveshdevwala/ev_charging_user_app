/// File: lib/features/nearby_offers/data/models/redemption_model.dart
/// Purpose: Offer redemption tracking with QR code data
/// Belongs To: nearby_offers feature
/// Customization Guide:
///    - Modify QR expiry duration as needed
///    - Add additional validation fields
library;

import 'package:equatable/equatable.dart';

import 'partner_offer_model.dart';

/// Redemption model for tracking offer usage.
class RedemptionModel extends Equatable {
  const RedemptionModel({
    required this.id,
    required this.offerId,
    required this.offerTitle,
    required this.partnerId,
    required this.partnerName,
    required this.userId,
    required this.status,
    required this.createdAt,
    this.qrCode,
    this.qrExpiresAt,
    this.redeemedAt,
    this.partnerLogoUrl,
    this.discountApplied,
    this.originalAmount,
    this.finalAmount,
    this.transactionId,
  });

  factory RedemptionModel.fromJson(Map<String, dynamic> json) {
    return RedemptionModel(
      id: json['id'] as String? ?? '',
      offerId: json['offerId'] as String? ?? '',
      offerTitle: json['offerTitle'] as String? ?? '',
      partnerId: json['partnerId'] as String? ?? '',
      partnerName: json['partnerName'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      status: OfferStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String?),
        orElse: () => OfferStatus.pending,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      qrCode: json['qrCode'] as String?,
      qrExpiresAt: json['qrExpiresAt'] != null
          ? DateTime.parse(json['qrExpiresAt'] as String)
          : null,
      redeemedAt: json['redeemedAt'] != null
          ? DateTime.parse(json['redeemedAt'] as String)
          : null,
      partnerLogoUrl: json['partnerLogoUrl'] as String?,
      discountApplied: (json['discountApplied'] as num?)?.toDouble(),
      originalAmount: (json['originalAmount'] as num?)?.toDouble(),
      finalAmount: (json['finalAmount'] as num?)?.toDouble(),
      transactionId: json['transactionId'] as String?,
    );
  }

  final String id;
  final String offerId;
  final String offerTitle;
  final String partnerId;
  final String partnerName;
  final String userId;
  final OfferStatus status;
  final DateTime createdAt;
  final String? qrCode;
  final DateTime? qrExpiresAt;
  final DateTime? redeemedAt;
  final String? partnerLogoUrl;
  final double? discountApplied;
  final double? originalAmount;
  final double? finalAmount;
  final String? transactionId;

  /// Check if QR code is still valid.
  bool get isQrValid {
    if (qrExpiresAt == null) return true;
    return DateTime.now().isBefore(qrExpiresAt!);
  }

  /// Time remaining for QR code.
  Duration? get qrTimeRemaining {
    if (qrExpiresAt == null) return null;
    final remaining = qrExpiresAt!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Formatted QR expiry countdown.
  String get qrCountdown {
    final remaining = qrTimeRemaining;
    if (remaining == null) return 'No expiry';
    if (remaining.inSeconds <= 0) return 'Expired';

    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;

    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }

  /// Status display text.
  String get statusText {
    switch (status) {
      case OfferStatus.active:
        return 'Active';
      case OfferStatus.pending:
        return 'Pending';
      case OfferStatus.used:
        return 'Used';
      case OfferStatus.expired:
        return 'Expired';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'offerId': offerId,
      'offerTitle': offerTitle,
      'partnerId': partnerId,
      'partnerName': partnerName,
      'userId': userId,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'qrCode': qrCode,
      'qrExpiresAt': qrExpiresAt?.toIso8601String(),
      'redeemedAt': redeemedAt?.toIso8601String(),
      'partnerLogoUrl': partnerLogoUrl,
      'discountApplied': discountApplied,
      'originalAmount': originalAmount,
      'finalAmount': finalAmount,
      'transactionId': transactionId,
    };
  }

  RedemptionModel copyWith({
    String? id,
    String? offerId,
    String? offerTitle,
    String? partnerId,
    String? partnerName,
    String? userId,
    OfferStatus? status,
    DateTime? createdAt,
    String? qrCode,
    DateTime? qrExpiresAt,
    DateTime? redeemedAt,
    String? partnerLogoUrl,
    double? discountApplied,
    double? originalAmount,
    double? finalAmount,
    String? transactionId,
  }) {
    return RedemptionModel(
      id: id ?? this.id,
      offerId: offerId ?? this.offerId,
      offerTitle: offerTitle ?? this.offerTitle,
      partnerId: partnerId ?? this.partnerId,
      partnerName: partnerName ?? this.partnerName,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      qrCode: qrCode ?? this.qrCode,
      qrExpiresAt: qrExpiresAt ?? this.qrExpiresAt,
      redeemedAt: redeemedAt ?? this.redeemedAt,
      partnerLogoUrl: partnerLogoUrl ?? this.partnerLogoUrl,
      discountApplied: discountApplied ?? this.discountApplied,
      originalAmount: originalAmount ?? this.originalAmount,
      finalAmount: finalAmount ?? this.finalAmount,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    offerId,
    offerTitle,
    partnerId,
    partnerName,
    userId,
    status,
    createdAt,
    qrCode,
    qrExpiresAt,
    redeemedAt,
    partnerLogoUrl,
    discountApplied,
    originalAmount,
    finalAmount,
    transactionId,
  ];
}

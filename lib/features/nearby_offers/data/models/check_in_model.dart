/// File: lib/features/nearby_offers/data/models/check_in_model.dart
/// Purpose: Check-in log entity for tracking partner visits
/// Belongs To: nearby_offers feature
/// Customization Guide:
///    - Add new validation rules as needed
///    - Extend with additional check-in metadata
library;

import 'package:equatable/equatable.dart';

/// Check-in validation status.
enum CheckInStatus { success, pending, failed, outOfRange, dailyLimitReached }

/// Check-in model for partner visits.
class CheckInModel extends Equatable {
  const CheckInModel({
    required this.id,
    required this.partnerId,
    required this.partnerName,
    required this.userId,
    required this.checkInTime,
    required this.status,
    this.partnerLogoUrl,
    this.userLatitude,
    this.userLongitude,
    this.partnerLatitude,
    this.partnerLongitude,
    this.distanceMeters,
    this.creditsEarned = 0,
    this.validationMessage,
  });

  factory CheckInModel.fromJson(Map<String, dynamic> json) {
    return CheckInModel(
      id: json['id'] as String? ?? '',
      partnerId: json['partnerId'] as String? ?? '',
      partnerName: json['partnerName'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      checkInTime: json['checkInTime'] != null
          ? DateTime.parse(json['checkInTime'] as String)
          : DateTime.now(),
      status: CheckInStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String?),
        orElse: () => CheckInStatus.pending,
      ),
      partnerLogoUrl: json['partnerLogoUrl'] as String?,
      userLatitude: (json['userLatitude'] as num?)?.toDouble(),
      userLongitude: (json['userLongitude'] as num?)?.toDouble(),
      partnerLatitude: (json['partnerLatitude'] as num?)?.toDouble(),
      partnerLongitude: (json['partnerLongitude'] as num?)?.toDouble(),
      distanceMeters: (json['distanceMeters'] as num?)?.toDouble(),
      creditsEarned: json['creditsEarned'] as int? ?? 0,
      validationMessage: json['validationMessage'] as String?,
    );
  }

  final String id;
  final String partnerId;
  final String partnerName;
  final String userId;
  final DateTime checkInTime;
  final CheckInStatus status;
  final String? partnerLogoUrl;
  final double? userLatitude;
  final double? userLongitude;
  final double? partnerLatitude;
  final double? partnerLongitude;
  final double? distanceMeters;
  final int creditsEarned;
  final String? validationMessage;

  /// Check if check-in was successful.
  bool get isSuccess => status == CheckInStatus.success;

  /// Get formatted check-in date.
  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(checkInTime);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes}m ago';
      }
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }
    return '${checkInTime.day}/${checkInTime.month}/${checkInTime.year}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partnerId': partnerId,
      'partnerName': partnerName,
      'userId': userId,
      'checkInTime': checkInTime.toIso8601String(),
      'status': status.name,
      'partnerLogoUrl': partnerLogoUrl,
      'userLatitude': userLatitude,
      'userLongitude': userLongitude,
      'partnerLatitude': partnerLatitude,
      'partnerLongitude': partnerLongitude,
      'distanceMeters': distanceMeters,
      'creditsEarned': creditsEarned,
      'validationMessage': validationMessage,
    };
  }

  CheckInModel copyWith({
    String? id,
    String? partnerId,
    String? partnerName,
    String? userId,
    DateTime? checkInTime,
    CheckInStatus? status,
    String? partnerLogoUrl,
    double? userLatitude,
    double? userLongitude,
    double? partnerLatitude,
    double? partnerLongitude,
    double? distanceMeters,
    int? creditsEarned,
    String? validationMessage,
  }) {
    return CheckInModel(
      id: id ?? this.id,
      partnerId: partnerId ?? this.partnerId,
      partnerName: partnerName ?? this.partnerName,
      userId: userId ?? this.userId,
      checkInTime: checkInTime ?? this.checkInTime,
      status: status ?? this.status,
      partnerLogoUrl: partnerLogoUrl ?? this.partnerLogoUrl,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      partnerLatitude: partnerLatitude ?? this.partnerLatitude,
      partnerLongitude: partnerLongitude ?? this.partnerLongitude,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      creditsEarned: creditsEarned ?? this.creditsEarned,
      validationMessage: validationMessage ?? this.validationMessage,
    );
  }

  @override
  List<Object?> get props => [
    id,
    partnerId,
    partnerName,
    userId,
    checkInTime,
    status,
    partnerLogoUrl,
    userLatitude,
    userLongitude,
    partnerLatitude,
    partnerLongitude,
    distanceMeters,
    creditsEarned,
    validationMessage,
  ];
}

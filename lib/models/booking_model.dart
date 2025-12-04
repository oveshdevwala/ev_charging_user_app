/// File: lib/models/booking_model.dart
/// Purpose: Booking data model
/// Belongs To: shared
/// Customization Guide:
///    - Add new fields as needed
///    - Update copyWith and JSON methods accordingly

import 'package:equatable/equatable.dart';

/// Booking status enum.
enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
  failed,
}

/// Payment status enum.
enum PaymentStatus {
  pending,
  paid,
  refunded,
  failed,
}

/// Booking model representing charging session reservations.
class BookingModel extends Equatable {
  const BookingModel({
    required this.id,
    required this.userId,
    required this.stationId,
    required this.chargerId,
    required this.startTime,
    this.endTime,
    this.stationName,
    this.stationAddress,
    this.chargerName,
    this.chargerType,
    this.status = BookingStatus.pending,
    this.paymentStatus = PaymentStatus.pending,
    this.estimatedDuration = 0,
    this.actualDuration,
    this.estimatedCost = 0.0,
    this.actualCost,
    this.energyDelivered,
    this.paymentMethod,
    this.transactionId,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });
  
  final String id;
  final String userId;
  final String stationId;
  final String chargerId;
  final DateTime startTime;
  final DateTime? endTime;
  final String? stationName;
  final String? stationAddress;
  final String? chargerName;
  final String? chargerType;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final int estimatedDuration; // in minutes
  final int? actualDuration; // in minutes
  final double estimatedCost;
  final double? actualCost;
  final double? energyDelivered; // in kWh
  final String? paymentMethod;
  final String? transactionId;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  /// Check if booking is active.
  bool get isActive => 
      status == BookingStatus.confirmed || 
      status == BookingStatus.inProgress;
  
  /// Check if booking is completed.
  bool get isCompleted => status == BookingStatus.completed;
  
  /// Check if booking is cancelled.
  bool get isCancelled => status == BookingStatus.cancelled;
  
  /// Check if booking is upcoming.
  bool get isUpcoming => 
      status == BookingStatus.confirmed && 
      startTime.isAfter(DateTime.now());
  
  /// Check if booking is past.
  bool get isPast => 
      status == BookingStatus.completed || 
      status == BookingStatus.cancelled;
  
  /// Get formatted duration string.
  String get durationDisplay {
    final duration = actualDuration ?? estimatedDuration;
    if (duration < 60) return '$duration min';
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    return minutes > 0 ? '$hours h $minutes min' : '$hours h';
  }
  
  /// Get cost display string.
  String get costDisplay {
    final cost = actualCost ?? estimatedCost;
    return '\$${cost.toStringAsFixed(2)}';
  }
  
  /// Create from JSON map.
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      stationId: json['stationId'] as String? ?? json['station_id'] as String? ?? '',
      chargerId: json['chargerId'] as String? ?? json['charger_id'] as String? ?? '',
      startTime: DateTime.tryParse(json['startTime'] as String? ?? 
                                   json['start_time'] as String? ?? '') ?? 
                 DateTime.now(),
      endTime: json['endTime'] != null 
          ? DateTime.tryParse(json['endTime'] as String) 
          : json['end_time'] != null
              ? DateTime.tryParse(json['end_time'] as String)
              : null,
      stationName: json['stationName'] as String? ?? json['station_name'] as String?,
      stationAddress: json['stationAddress'] as String? ?? json['station_address'] as String?,
      chargerName: json['chargerName'] as String? ?? json['charger_name'] as String?,
      chargerType: json['chargerType'] as String? ?? json['charger_type'] as String?,
      status: BookingStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String?),
        orElse: () => BookingStatus.pending,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (s) => s.name == (json['paymentStatus'] as String? ?? json['payment_status'] as String?),
        orElse: () => PaymentStatus.pending,
      ),
      estimatedDuration: json['estimatedDuration'] as int? ?? 
                        json['estimated_duration'] as int? ?? 0,
      actualDuration: json['actualDuration'] as int? ?? json['actual_duration'] as int?,
      estimatedCost: (json['estimatedCost'] as num?)?.toDouble() ?? 
                    (json['estimated_cost'] as num?)?.toDouble() ?? 0.0,
      actualCost: (json['actualCost'] as num?)?.toDouble() ?? 
                 (json['actual_cost'] as num?)?.toDouble(),
      energyDelivered: (json['energyDelivered'] as num?)?.toDouble() ??
                      (json['energy_delivered'] as num?)?.toDouble(),
      paymentMethod: json['paymentMethod'] as String? ?? json['payment_method'] as String?,
      transactionId: json['transactionId'] as String? ?? json['transaction_id'] as String?,
      notes: json['notes'] as String?,
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
      'userId': userId,
      'stationId': stationId,
      'chargerId': chargerId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'stationName': stationName,
      'stationAddress': stationAddress,
      'chargerName': chargerName,
      'chargerType': chargerType,
      'status': status.name,
      'paymentStatus': paymentStatus.name,
      'estimatedDuration': estimatedDuration,
      'actualDuration': actualDuration,
      'estimatedCost': estimatedCost,
      'actualCost': actualCost,
      'energyDelivered': energyDelivered,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
  
  /// Copy with new values.
  BookingModel copyWith({
    String? id,
    String? userId,
    String? stationId,
    String? chargerId,
    DateTime? startTime,
    DateTime? endTime,
    String? stationName,
    String? stationAddress,
    String? chargerName,
    String? chargerType,
    BookingStatus? status,
    PaymentStatus? paymentStatus,
    int? estimatedDuration,
    int? actualDuration,
    double? estimatedCost,
    double? actualCost,
    double? energyDelivered,
    String? paymentMethod,
    String? transactionId,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      stationId: stationId ?? this.stationId,
      chargerId: chargerId ?? this.chargerId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      stationName: stationName ?? this.stationName,
      stationAddress: stationAddress ?? this.stationAddress,
      chargerName: chargerName ?? this.chargerName,
      chargerType: chargerType ?? this.chargerType,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      actualCost: actualCost ?? this.actualCost,
      energyDelivered: energyDelivered ?? this.energyDelivered,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    userId,
    stationId,
    chargerId,
    startTime,
    endTime,
    stationName,
    stationAddress,
    chargerName,
    chargerType,
    status,
    paymentStatus,
    estimatedDuration,
    actualDuration,
    estimatedCost,
    actualCost,
    energyDelivered,
    paymentMethod,
    transactionId,
    notes,
    createdAt,
    updatedAt,
  ];
}


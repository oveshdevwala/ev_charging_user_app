/// File: lib/admin/features/payments/models/payment.dart
/// Purpose: Payment domain models and enums for admin payments module
/// Belongs To: admin/features/payments
/// Customization Guide:
/// - Extend enums when adding new payment methods/statuses
/// - Add additional fields (tax, fee) as backend evolves
library;

import 'package:equatable/equatable.dart';

/// Supported payment statuses.
enum AdminPaymentStatus { pending, completed, failed, refunded }

/// Supported payment methods.
enum AdminPaymentMethod { card, wallet, upi }

/// Timeline entry to show payment history in UI.
class AdminPaymentTimelineEntry extends Equatable {
  const AdminPaymentTimelineEntry({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.status,
  });

  factory AdminPaymentTimelineEntry.fromJson(Map<String, dynamic> json) {
    return AdminPaymentTimelineEntry(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      status: _statusFromString(json['status'] as String?),
    );
  }

  final String title;
  final String description;
  final DateTime timestamp;
  final AdminPaymentStatus status;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'status': status.name,
    };
  }

  AdminPaymentTimelineEntry copyWith({
    String? title,
    String? description,
    DateTime? timestamp,
    AdminPaymentStatus? status,
  }) {
    return AdminPaymentTimelineEntry(
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [title, description, timestamp, status];
}

/// Payment model used across list and detail surfaces.
class AdminPayment extends Equatable {
  const AdminPayment({
    required this.id,
    required this.transactionId,
    required this.userId,
    required this.userName,
    required this.stationName,
    required this.amount,
    required this.currency,
    required this.status,
    required this.method,
    required this.createdAt,
    required this.updatedAt,
    required this.referenceId,
    required this.timeline,
    this.sessionId,
    this.notes,
    this.imageUrl,
  });

  factory AdminPayment.fromJson(Map<String, dynamic> json) {
    return AdminPayment(
      id: json['id'] as String? ?? '',
      transactionId: json['transactionId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      stationName: json['stationName'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'USD',
      status: _statusFromString(json['status'] as String?),
      method: _methodFromString(json['method'] as String?),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      referenceId: json['referenceId'] as String? ?? '',
      sessionId: json['sessionId'] as String?,
      notes: json['notes'] as String?,
      imageUrl: json['imageUrl'] as String?,
      timeline: (json['timeline'] as List<dynamic>? ?? [])
          .map((item) =>
              AdminPaymentTimelineEntry.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  final String id;
  final String transactionId;
  final String userId;
  final String userName;
  final String stationName;
  final double amount;
  final String currency;
  final AdminPaymentStatus status;
  final AdminPaymentMethod method;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String referenceId;
  final String? sessionId;
  final String? notes;
  final String? imageUrl;
  final List<AdminPaymentTimelineEntry> timeline;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionId': transactionId,
      'userId': userId,
      'userName': userName,
      'stationName': stationName,
      'amount': amount,
      'currency': currency,
      'status': status.name,
      'method': method.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'referenceId': referenceId,
      'sessionId': sessionId,
      'notes': notes,
      'imageUrl': imageUrl,
      'timeline': timeline.map((t) => t.toJson()).toList(),
    };
  }

  AdminPayment copyWith({
    String? id,
    String? transactionId,
    String? userId,
    String? userName,
    String? stationName,
    double? amount,
    String? currency,
    AdminPaymentStatus? status,
    AdminPaymentMethod? method,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? referenceId,
    String? sessionId,
    String? notes,
    String? imageUrl,
    List<AdminPaymentTimelineEntry>? timeline,
  }) {
    return AdminPayment(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      stationName: stationName ?? this.stationName,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      method: method ?? this.method,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      referenceId: referenceId ?? this.referenceId,
      sessionId: sessionId ?? this.sessionId,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      timeline: timeline ?? this.timeline,
    );
  }

  @override
  List<Object?> get props => [
        id,
        transactionId,
        userId,
        userName,
        stationName,
        amount,
        currency,
        status,
        method,
        createdAt,
        updatedAt,
        referenceId,
        sessionId,
        notes,
        imageUrl,
        timeline,
      ];
}

AdminPaymentStatus _statusFromString(String? value) {
  switch (value) {
    case 'completed':
      return AdminPaymentStatus.completed;
    case 'failed':
      return AdminPaymentStatus.failed;
    case 'refunded':
      return AdminPaymentStatus.refunded;
    case 'pending':
    default:
      return AdminPaymentStatus.pending;
  }
}

AdminPaymentMethod _methodFromString(String? value) {
  switch (value) {
    case 'wallet':
      return AdminPaymentMethod.wallet;
    case 'upi':
      return AdminPaymentMethod.upi;
    case 'card':
    default:
      return AdminPaymentMethod.card;
  }
}

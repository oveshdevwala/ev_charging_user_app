/// File: lib/admin/features/partners/models/partner_contract_model.dart
/// Purpose: Partner contract domain model
/// Belongs To: admin/features/partners
/// Customization Guide:
///    - Add additional contract fields as needed
library;

import 'package:equatable/equatable.dart';

import 'partner_enums.dart';

/// Partner contract model.
class PartnerContractModel extends Equatable {
  const PartnerContractModel({
    required this.id,
    required this.partnerId,
    required this.title,
    required this.startDate,
    required this.status,
    required this.amount,
    required this.currency,
    this.endDate,
    this.notes,
  });

  factory PartnerContractModel.fromJson(Map<String, dynamic> json) {
    return PartnerContractModel(
      id: json['id'] as String? ?? '',
      partnerId: json['partnerId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      startDate:
          DateTime.tryParse(json['startDate'] as String? ?? '') ??
          DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'] as String)
          : null,
      status: contractStatusFromString(json['status'] as String?),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'USD',
      notes: json['notes'] as String?,
    );
  }

  final String id;
  final String partnerId;
  final String title;
  final DateTime startDate;
  final DateTime? endDate;
  final ContractStatus status;
  final double amount;
  final String currency;
  final String? notes;

  /// Check if contract is ongoing (no end date or future end date).
  bool get isOngoing {
    if (endDate == null) {
      return true;
    }
    return DateTime.now().isBefore(endDate!);
  }

  /// Formatted amount with currency symbol.
  String get formattedAmount {
    final symbol = _getCurrencySymbol(currency);
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  /// Formatted status name.
  String get statusName {
    switch (status) {
      case ContractStatus.active:
        return 'Active';
      case ContractStatus.expired:
        return 'Expired';
      case ContractStatus.terminated:
        return 'Terminated';
    }
  }

  String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return r'$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'INR':
        return '₹';
      default:
        return currency;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partnerId': partnerId,
      'title': title,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status.name,
      'amount': amount,
      'currency': currency,
      'notes': notes,
    };
  }

  PartnerContractModel copyWith({
    String? id,
    String? partnerId,
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    ContractStatus? status,
    double? amount,
    String? currency,
    String? notes,
  }) {
    return PartnerContractModel(
      id: id ?? this.id,
      partnerId: partnerId ?? this.partnerId,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    partnerId,
    title,
    startDate,
    endDate,
    status,
    amount,
    currency,
    notes,
  ];
}

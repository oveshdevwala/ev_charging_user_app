/// File: lib/features/profile/models/payment_method_model.dart
/// Purpose: Payment method model with JSON serialization
/// Belongs To: profile feature
/// Customization Guide:
///    - Add new payment method types as needed
///    - Run build_runner to generate JSON code
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_method_model.g.dart';

/// Payment method types.
enum PaymentMethodType {
  card,
  wallet,
  bankAccount,
}

/// Payment method model.
/// Note: Never stores raw card data, only tokenized references.
@JsonSerializable()
class PaymentMethodModel extends Equatable {
  const PaymentMethodModel({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    this.isDefault = false,
    this.gatewayToken,
    this.type = PaymentMethodType.card,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);

  final String id;
  final String brand;
  final String last4;
  final int expMonth;
  final int expYear;
  final bool isDefault;
  final String? gatewayToken;

  @JsonKey(fromJson: _typeFromJson, toJson: _typeToJson)
  final PaymentMethodType type;

  /// Get formatted expiry date.
  String get formattedExpiry => '$expMonth/${expYear.toString().substring(2)}';

  /// Get masked card number.
  String get maskedNumber => '**** **** **** $last4';

  Map<String, dynamic> toJson() => _$PaymentMethodModelToJson(this);

  /// Copy with new values.
  PaymentMethodModel copyWith({
    String? id,
    String? brand,
    String? last4,
    int? expMonth,
    int? expYear,
    bool? isDefault,
    String? gatewayToken,
    PaymentMethodType? type,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      last4: last4 ?? this.last4,
      expMonth: expMonth ?? this.expMonth,
      expYear: expYear ?? this.expYear,
      isDefault: isDefault ?? this.isDefault,
      gatewayToken: gatewayToken ?? this.gatewayToken,
      type: type ?? this.type,
    );
  }

  static PaymentMethodType _typeFromJson(String value) {
    return PaymentMethodType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PaymentMethodType.card,
    );
  }

  static String _typeToJson(PaymentMethodType type) => type.name;

  @override
  List<Object?> get props => [
        id,
        brand,
        last4,
        expMonth,
        expYear,
        isDefault,
        gatewayToken,
        type,
      ];
}


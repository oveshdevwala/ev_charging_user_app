/// File: lib/features/profile/models/wallet_model.dart
/// Purpose: Wallet model with JSON serialization
/// Belongs To: profile feature
/// Customization Guide:
///    - Add new wallet fields as needed
///    - Run build_runner to generate JSON code
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet_model.g.dart';

/// Wallet transaction type.
enum WalletTransactionType {
  credit,
  debit,
}

/// Wallet transaction model.
@JsonSerializable()
class WalletTransactionModel extends Equatable {
  const WalletTransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.createdAt,
    this.referenceId,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionModelFromJson(json);

  @JsonKey(fromJson: _typeFromJson, toJson: _typeToJson)
  final WalletTransactionType type;

  final String id;
  final double amount;
  final String description;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  final String? referenceId;

  Map<String, dynamic> toJson() => _$WalletTransactionModelToJson(this);

  /// Copy with new values.
  WalletTransactionModel copyWith({
    String? id,
    WalletTransactionType? type,
    double? amount,
    String? description,
    DateTime? createdAt,
    String? referenceId,
  }) {
    return WalletTransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      referenceId: referenceId ?? this.referenceId,
    );
  }

  static WalletTransactionType _typeFromJson(String value) {
    return WalletTransactionType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => WalletTransactionType.credit,
    );
  }

  static String _typeToJson(WalletTransactionType type) => type.name;

  static DateTime _dateTimeFromJson(value) {
    if (value is String) {
      return DateTime.parse(value);
    }
    return DateTime.now();
  }

  static String _dateTimeToJson(DateTime date) => date.toIso8601String();

  @override
  List<Object?> get props => [id, type, amount, description, createdAt, referenceId];
}

/// Wallet model.
@JsonSerializable()
class WalletModel extends Equatable {
  const WalletModel({
    required this.balance,
    this.currency = 'USD',
    this.transactions = const [],
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);

  final double balance;
  final String currency;
  final List<WalletTransactionModel> transactions;

  Map<String, dynamic> toJson() => _$WalletModelToJson(this);

  /// Copy with new values.
  WalletModel copyWith({
    double? balance,
    String? currency,
    List<WalletTransactionModel>? transactions,
  }) {
    return WalletModel(
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  List<Object?> get props => [balance, currency, transactions];
}


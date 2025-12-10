/// File: lib/admin/features/wallets/models/wallet_model.dart
/// Purpose: Wallet domain model for admin wallets module
/// Belongs To: admin/features/wallets
/// Customization Guide:
/// - Extend enums when adding new wallet statuses/currencies
/// - Add additional fields as backend evolves
library;

import 'package:equatable/equatable.dart';

/// Supported wallet statuses.
enum WalletStatus { active, frozen }

/// Supported currencies.
enum WalletCurrency { usd, inr, eur, gbp }

/// Wallet model used across list and detail surfaces.
class WalletModel extends Equatable {
  const WalletModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.currency,
    required this.balance,
    required this.reserved,
    required this.available,
    required this.status,
    required this.createdAt,
    required this.lastActivity,
    this.avatarUrl,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      userEmail: json['userEmail'] as String? ?? '',
      currency: _currencyFromString(json['currency'] as String?),
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      reserved: (json['reserved'] as num?)?.toDouble() ?? 0.0,
      available: (json['available'] as num?)?.toDouble() ?? 0.0,
      status: _statusFromString(json['status'] as String?),
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      lastActivity:
          DateTime.tryParse(json['lastActivity'] as String? ?? '') ??
          DateTime.now(),
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final WalletCurrency currency;
  final double balance;
  final double reserved;
  final double available;
  final WalletStatus status;
  final DateTime createdAt;
  final DateTime lastActivity;
  final String? avatarUrl;

  String get currencySymbol {
    switch (currency) {
      case WalletCurrency.usd:
        return r'$';
      case WalletCurrency.inr:
        return '₹';
      case WalletCurrency.eur:
        return '€';
      case WalletCurrency.gbp:
        return '£';
    }
  }

  String get currencyCode {
    switch (currency) {
      case WalletCurrency.usd:
        return 'USD';
      case WalletCurrency.inr:
        return 'INR';
      case WalletCurrency.eur:
        return 'EUR';
      case WalletCurrency.gbp:
        return 'GBP';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'currency': currency.name.toUpperCase(),
      'balance': balance,
      'reserved': reserved,
      'available': available,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'lastActivity': lastActivity.toIso8601String(),
      'avatarUrl': avatarUrl,
    };
  }

  WalletModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    WalletCurrency? currency,
    double? balance,
    double? reserved,
    double? available,
    WalletStatus? status,
    DateTime? createdAt,
    DateTime? lastActivity,
    String? avatarUrl,
  }) {
    return WalletModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      currency: currency ?? this.currency,
      balance: balance ?? this.balance,
      reserved: reserved ?? this.reserved,
      available: available ?? this.available,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastActivity: lastActivity ?? this.lastActivity,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    userEmail,
    currency,
    balance,
    reserved,
    available,
    status,
    createdAt,
    lastActivity,
    avatarUrl,
  ];
}

WalletStatus _statusFromString(String? value) {
  switch (value?.toLowerCase()) {
    case 'frozen':
      return WalletStatus.frozen;
    case 'active':
    default:
      return WalletStatus.active;
  }
}

WalletCurrency _currencyFromString(String? value) {
  switch (value?.toUpperCase()) {
    case 'INR':
      return WalletCurrency.inr;
    case 'EUR':
      return WalletCurrency.eur;
    case 'GBP':
      return WalletCurrency.gbp;
    case 'USD':
    default:
      return WalletCurrency.usd;
  }
}

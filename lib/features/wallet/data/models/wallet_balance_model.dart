/// File: lib/features/wallet/data/models/wallet_balance_model.dart
/// Purpose: Wallet balance data model with available/pending amounts
/// Belongs To: wallet feature
/// Customization Guide:
///    - Modify currency handling as needed
///    - Add new balance types (bonus, rewards, etc.)
library;

import 'package:equatable/equatable.dart';

/// Wallet balance model containing all balance-related information.
/// 
/// ## Fields:
/// - [totalBalance]: Total available balance
/// - [availableBalance]: Balance available for use
/// - [pendingBalance]: Balance pending confirmation
/// - [rewardsBalance]: Earned rewards/credits balance
/// - [currency]: Currency code (e.g., USD, INR)
/// - [lastUpdated]: Last time balance was updated
class WalletBalanceModel extends Equatable {
  const WalletBalanceModel({
    required this.totalBalance,
    required this.availableBalance,
    required this.lastUpdated, this.pendingBalance = 0.0,
    this.rewardsBalance = 0.0,
    this.currency = 'USD',
  });

  /// Create from JSON map
  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) {
    return WalletBalanceModel(
      totalBalance: (json['totalBalance'] as num?)?.toDouble() ?? 0.0,
      availableBalance: (json['availableBalance'] as num?)?.toDouble() ?? 0.0,
      pendingBalance: (json['pendingBalance'] as num?)?.toDouble() ?? 0.0,
      rewardsBalance: (json['rewardsBalance'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'USD',
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
    );
  }

  /// Empty wallet balance
  factory WalletBalanceModel.empty() => WalletBalanceModel(
        totalBalance: 0,
        availableBalance: 0,
        lastUpdated: DateTime.now(),
      );

  /// Total wallet balance
  final double totalBalance;

  /// Balance available for immediate use
  final double availableBalance;

  /// Balance pending confirmation
  final double pendingBalance;

  /// Rewards/credits balance
  final double rewardsBalance;

  /// Currency code
  final String currency;

  /// Last balance update timestamp
  final DateTime lastUpdated;

  /// Currency symbol based on currency code
  String get currencySymbol {
    switch (currency) {
      case 'INR':
        return '₹';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'USD':
      default:
        return r'$';
    }
  }

  /// Formatted total balance with currency symbol
  String get formattedTotalBalance =>
      '$currencySymbol${totalBalance.toStringAsFixed(2)}';

  /// Formatted available balance with currency symbol
  String get formattedAvailableBalance =>
      '$currencySymbol${availableBalance.toStringAsFixed(2)}';

  /// Formatted pending balance with currency symbol
  String get formattedPendingBalance =>
      '$currencySymbol${pendingBalance.toStringAsFixed(2)}';

  /// Formatted rewards balance with currency symbol
  String get formattedRewardsBalance =>
      '$currencySymbol${rewardsBalance.toStringAsFixed(2)}';

  /// Check if there's sufficient balance for an amount
  bool hasSufficientBalance(double amount) => availableBalance >= amount;

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'totalBalance': totalBalance,
      'availableBalance': availableBalance,
      'pendingBalance': pendingBalance,
      'rewardsBalance': rewardsBalance,
      'currency': currency,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Copy with new values
  WalletBalanceModel copyWith({
    double? totalBalance,
    double? availableBalance,
    double? pendingBalance,
    double? rewardsBalance,
    String? currency,
    DateTime? lastUpdated,
  }) {
    return WalletBalanceModel(
      totalBalance: totalBalance ?? this.totalBalance,
      availableBalance: availableBalance ?? this.availableBalance,
      pendingBalance: pendingBalance ?? this.pendingBalance,
      rewardsBalance: rewardsBalance ?? this.rewardsBalance,
      currency: currency ?? this.currency,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        totalBalance,
        availableBalance,
        pendingBalance,
        rewardsBalance,
        currency,
        lastUpdated,
      ];
}


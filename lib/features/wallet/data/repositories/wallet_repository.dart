/// File: lib/features/wallet/data/repositories/wallet_repository.dart
/// Purpose: Wallet repository interface and dummy implementation
/// Belongs To: wallet feature
/// Customization Guide:
///    - Replace dummy data with actual API calls
///    - Add caching layer using sqflite
///    - Implement error handling for network failures
library;

import '../models/models.dart';

/// Abstract wallet repository interface.
/// 
/// ## Flow Diagram:
/// ```
/// UI -> BLoC -> Repository -> DataSource (API/Local)
/// ```
/// 
/// ## Methods:
/// - [getWalletBalance]: Fetch current wallet balance
/// - [getTransactions]: Fetch paginated transaction history
/// - [rechargeWallet]: Add money to wallet
/// - [applyPromoCode]: Validate and apply promo code
/// - [getCreditsSummary]: Get credits summary
/// - [getCreditsHistory]: Get paginated credits history
/// - [applyCashback]: Calculate and apply cashback
/// - [getCashbackHistory]: Get cashback history
abstract class WalletRepository {
  /// Fetch current wallet balance
  Future<WalletBalanceModel> getWalletBalance();

  /// Fetch paginated transaction history
  /// [page]: Page number (1-indexed)
  /// [limit]: Items per page
  /// [type]: Filter by transaction type (optional)
  Future<List<WalletTransactionModel>> getTransactions({
    int page = 1,
    int limit = 20,
    WalletTransactionType? type,
    DateTime? fromDate,
    DateTime? toDate,
  });

  /// Recharge wallet with given amount
  /// [amount]: Amount to add
  /// [paymentMethod]: Payment method used
  /// [promoCode]: Optional promo code to apply
  Future<WalletTransactionModel> rechargeWallet({
    required double amount,
    required String paymentMethod,
    PromoCodeModel? promoCode,
  });

  /// Validate and apply promo code
  /// [code]: Promo code string
  /// [amount]: Amount to apply promo on
  Future<PromoCodeResult> applyPromoCode({
    required String code,
    required double amount,
  });

  /// Get available promo codes for user
  Future<List<PromoCodeModel>> getAvailablePromoCodes();

  /// Get credits summary
  Future<CreditsSummaryModel> getCreditsSummary();

  /// Get paginated credits history
  Future<List<CreditEntryModel>> getCreditsHistory({
    int page = 1,
    int limit = 20,
  });

  /// Calculate credits for a charging session
  /// [sessionAmount]: Amount spent in session
  /// Returns: Number of credits earned
  Future<int> calculateCreditsEarned(double sessionAmount);

  /// Check if station is eligible for cashback
  Future<PartnerStationModel?> checkCashbackEligibility(String stationId);

  /// Apply cashback for a charging session
  Future<CashbackModel?> applyCashback({
    required String sessionId,
    required String stationId,
    required double amount,
  });

  /// Get cashback history
  Future<List<CashbackModel>> getCashbackHistory({
    int page = 1,
    int limit = 20,
  });
}

/// Dummy implementation of wallet repository.
/// 
/// ## Purpose:
/// Provides mock data for development and testing.
/// Replace with actual API implementation for production.
class DummyWalletRepository implements WalletRepository {
  // Dummy wallet balance
  WalletBalanceModel _balance = WalletBalanceModel(
    totalBalance: 125.50,
    availableBalance: 120,
    pendingBalance: 5.50,
    rewardsBalance: 15,
    lastUpdated: DateTime.now(),
  );

  // Dummy transactions
  final List<WalletTransactionModel> _transactions = [
    WalletTransactionModel(
      id: 'tx_001',
      type: WalletTransactionType.recharge,
      amount: 50,
      status: WalletTransactionStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      description: 'Wallet recharge via Credit Card',
      referenceId: 'PAY_123456',
      balanceAfter: 125.50,
    ),
    WalletTransactionModel(
      id: 'tx_002',
      type: WalletTransactionType.charging,
      amount: 15.50,
      status: WalletTransactionStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      stationName: 'Downtown EV Hub',
      sessionId: 'sess_001',
      description: 'Charging session - 12.5 kWh',
      balanceAfter: 75.50,
    ),
    WalletTransactionModel(
      id: 'tx_003',
      type: WalletTransactionType.cashback,
      amount: 2.50,
      status: WalletTransactionStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      stationName: 'Downtown EV Hub',
      cashbackPercentage: 10,
      description: '10% cashback on partner station',
      balanceAfter: 78,
    ),
    WalletTransactionModel(
      id: 'tx_004',
      type: WalletTransactionType.charging,
      amount: 22,
      status: WalletTransactionStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      stationName: 'Highway Supercharger',
      sessionId: 'sess_002',
      description: 'Charging session - 18.0 kWh',
      balanceAfter: 91,
    ),
    WalletTransactionModel(
      id: 'tx_005',
      type: WalletTransactionType.promoCredit,
      amount: 10,
      status: WalletTransactionStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      promoCode: 'WELCOME10',
      description: 'Welcome bonus - WELCOME10',
      balanceAfter: 113,
    ),
    WalletTransactionModel(
      id: 'tx_006',
      type: WalletTransactionType.recharge,
      amount: 100,
      status: WalletTransactionStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      description: 'Wallet recharge via UPI',
      referenceId: 'PAY_789012',
      balanceAfter: 103,
    ),
    WalletTransactionModel(
      id: 'tx_007',
      type: WalletTransactionType.referral,
      amount: 5,
      status: WalletTransactionStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      description: 'Referral bonus - John Doe signed up',
      balanceAfter: 3,
    ),
  ];

  // Dummy promo codes
  final List<PromoCodeModel> _promoCodes = [
    PromoCodeModel(
      id: 'promo_001',
      code: 'CHARGE20',
      discountType: PromoDiscountType.percentage,
      discountValue: 20,
      validFrom: DateTime.now().subtract(const Duration(days: 10)),
      validUntil: DateTime.now().add(const Duration(days: 20)),
      title: '20% Off Recharge',
      description: 'Get 20% off on your next wallet recharge',
      minSpend: 50,
      maxDiscount: 25,
      terms: const [
        r'Valid on recharges above $50',
        r'Maximum discount of $25',
        'Cannot be combined with other offers',
      ],
    ),
    PromoCodeModel(
      id: 'promo_002',
      code: 'FLAT10',
      discountType: PromoDiscountType.fixed,
      discountValue: 10,
      validFrom: DateTime.now().subtract(const Duration(days: 5)),
      validUntil: DateTime.now().add(const Duration(days: 25)),
      title: r'$10 Flat Off',
      description: r'Flat $10 off on minimum $30 recharge',
      minSpend: 30,
      terms: const [
        r'Valid on recharges above $30',
        'One-time use only',
      ],
    ),
    PromoCodeModel(
      id: 'promo_003',
      code: 'CASHBACK15',
      discountType: PromoDiscountType.cashback,
      discountValue: 15,
      validFrom: DateTime.now().subtract(const Duration(days: 2)),
      validUntil: DateTime.now().add(const Duration(days: 15)),
      title: '15% Cashback',
      description: 'Get 15% cashback on your charging sessions',
      maxDiscount: 20,
      applicability: PromoApplicability.charging,
      terms: const [
        'Valid on all charging sessions',
        r'Maximum cashback of $20',
        'Cashback credited within 24 hours',
      ],
    ),
  ];

  // Dummy credits
  final List<CreditEntryModel> _creditEntries = [
    CreditEntryModel(
      id: 'cr_001',
      credits: 15,
      source: CreditSource.charging,
      earnedAt: DateTime.now().subtract(const Duration(hours: 5)),
      expiresAt: DateTime.now().add(const Duration(days: 365)),
      stationName: 'Downtown EV Hub',
      amountSpent: 15.50,
      description: 'Credits for charging session',
    ),
    CreditEntryModel(
      id: 'cr_002',
      credits: 22,
      source: CreditSource.charging,
      earnedAt: DateTime.now().subtract(const Duration(days: 1)),
      expiresAt: DateTime.now().add(const Duration(days: 364)),
      stationName: 'Highway Supercharger',
      amountSpent: 22,
      description: 'Credits for charging session',
    ),
    CreditEntryModel(
      id: 'cr_003',
      credits: 50,
      source: CreditSource.signup,
      earnedAt: DateTime.now().subtract(const Duration(days: 7)),
      expiresAt: DateTime.now().add(const Duration(days: 90)),
      description: 'Welcome bonus credits',
    ),
    CreditEntryModel(
      id: 'cr_004',
      credits: 25,
      source: CreditSource.referral,
      earnedAt: DateTime.now().subtract(const Duration(days: 5)),
      expiresAt: DateTime.now().add(const Duration(days: 180)),
      description: 'Referral bonus - John Doe',
    ),
    CreditEntryModel(
      id: 'cr_005',
      credits: 100,
      source: CreditSource.promotion,
      earnedAt: DateTime.now().subtract(const Duration(days: 10)),
      expiresAt: DateTime.now().add(const Duration(days: 30)),
      usedCredits: 40,
      description: 'Summer promotion bonus',
    ),
  ];

  // Dummy cashback history
  final List<CashbackModel> _cashbackHistory = [
    CashbackModel(
      id: 'cb_001',
      sessionId: 'sess_001',
      stationId: 'station_001',
      stationName: 'Downtown EV Hub',
      originalAmount: 25,
      cashbackPercentage: 10,
      cashbackAmount: 2.50,
      earnedAt: DateTime.now().subtract(const Duration(hours: 5)),
      status: CashbackStatus.credited,
      creditedAt: DateTime.now().subtract(const Duration(hours: 4)),
      isPartnerStation: true,
      partnerBadge: 'Gold Partner',
    ),
    CashbackModel(
      id: 'cb_002',
      sessionId: 'sess_003',
      stationId: 'station_003',
      stationName: 'Mall Charging Point',
      originalAmount: 18,
      cashbackPercentage: 5,
      cashbackAmount: 0.90,
      earnedAt: DateTime.now().subtract(const Duration(days: 3)),
      status: CashbackStatus.credited,
      creditedAt: DateTime.now().subtract(const Duration(days: 3)),
      isPartnerStation: true,
      partnerBadge: 'Silver Partner',
    ),
    CashbackModel(
      id: 'cb_003',
      sessionId: 'sess_005',
      stationId: 'station_005',
      stationName: 'Tech Park Station',
      originalAmount: 30,
      cashbackPercentage: 15,
      cashbackAmount: 4.50,
      earnedAt: DateTime.now().subtract(const Duration(days: 7)),
      status: CashbackStatus.credited,
      creditedAt: DateTime.now().subtract(const Duration(days: 7)),
      isPartnerStation: true,
      partnerBadge: 'Platinum Partner',
      type: CashbackType.promotion,
    ),
  ];

  // Partner stations
  final List<PartnerStationModel> _partnerStations = [
    const PartnerStationModel(
      stationId: 'station_001',
      stationName: 'Downtown EV Hub',
      cashbackPercentage: 10,
      partnerBadge: 'Gold Partner',
      partnerTier: 'gold',
    ),
    const PartnerStationModel(
      stationId: 'station_003',
      stationName: 'Mall Charging Point',
      cashbackPercentage: 5,
      partnerBadge: 'Silver Partner',
      partnerTier: 'silver',
    ),
    const PartnerStationModel(
      stationId: 'station_005',
      stationName: 'Tech Park Station',
      cashbackPercentage: 15,
      partnerBadge: 'Platinum Partner',
      partnerTier: 'platinum',
    ),
  ];

  @override
  Future<WalletBalanceModel> getWalletBalance() async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _balance;
  }

  @override
  Future<List<WalletTransactionModel>> getTransactions({
    int page = 1,
    int limit = 20,
    WalletTransactionType? type,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    var filtered = _transactions;

    // Filter by type
    if (type != null) {
      filtered = filtered.where((t) => t.type == type).toList();
    }

    // Filter by date range
    if (fromDate != null) {
      filtered = filtered.where((t) => t.createdAt.isAfter(fromDate)).toList();
    }
    if (toDate != null) {
      filtered = filtered.where((t) => t.createdAt.isBefore(toDate)).toList();
    }

    // Paginate
    final startIndex = (page - 1) * limit;
    if (startIndex >= filtered.length) {
      return [];
    }

    final endIndex =
        (startIndex + limit > filtered.length) ? filtered.length : startIndex + limit;

    return filtered.sublist(startIndex, endIndex);
  }

  @override
  Future<WalletTransactionModel> rechargeWallet({
    required double amount,
    required String paymentMethod,
    PromoCodeModel? promoCode,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    // Calculate discount if promo applied (for future use)
    if (promoCode != null) {
      promoCode.calculateDiscount(amount);
    }

    // Update balance
    _balance = _balance.copyWith(
      totalBalance: _balance.totalBalance + amount,
      availableBalance: _balance.availableBalance + amount,
      lastUpdated: DateTime.now(),
    );

    // Create transaction
    final transaction = WalletTransactionModel(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      type: WalletTransactionType.recharge,
      amount: amount,
      status: WalletTransactionStatus.completed,
      createdAt: DateTime.now(),
      description: 'Wallet recharge via $paymentMethod',
      referenceId: 'PAY_${DateTime.now().millisecondsSinceEpoch}',
      promoCode: promoCode?.code,
      balanceAfter: _balance.totalBalance,
    );

    _transactions.insert(0, transaction);

    return transaction;
  }

  @override
  Future<PromoCodeResult> applyPromoCode({
    required String code,
    required double amount,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Find promo code
    final promo = _promoCodes.where((p) => p.code.toUpperCase() == code.toUpperCase()).firstOrNull;

    if (promo == null) {
      return PromoCodeResult.failure('Invalid promo code');
    }

    // Validate
    final error = promo.validateForAmount(amount);
    if (error != null) {
      return PromoCodeResult.failure(error);
    }

    // Calculate discount
    final discount = promo.calculateDiscount(amount);

    return PromoCodeResult.success(
      promo: promo,
      discountAmount: discount,
    );
  }

  @override
  Future<List<PromoCodeModel>> getAvailablePromoCodes() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _promoCodes.where((p) => p.isValid).toList();
  }

  @override
  Future<CreditsSummaryModel> getCreditsSummary() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final totalCredits =
        _creditEntries.fold<int>(0, (sum, e) => sum + e.credits);
    final usedCredits =
        _creditEntries.fold<int>(0, (sum, e) => sum + e.usedCredits);
    final availableCredits = totalCredits - usedCredits;

    // Find expiring credits (within 30 days)
    final expiringEntries = _creditEntries.where(
      (e) =>
          e.daysUntilExpiry <= 30 &&
          e.daysUntilExpiry > 0 &&
          e.hasAvailableCredits,
    );
    final expiringCredits = expiringEntries.fold<int>(
      0,
      (sum, e) => sum + e.remainingCredits,
    );
    final minDaysToExpiry = expiringEntries.isEmpty
        ? 0
        : expiringEntries
            .map((e) => e.daysUntilExpiry)
            .reduce((a, b) => a < b ? a : b);

    return CreditsSummaryModel(
      totalCredits: totalCredits,
      availableCredits: availableCredits,
      usedCredits: usedCredits,
      expiringCredits: expiringCredits,
      expiringInDays: minDaysToExpiry,
      creditValue: 0.01,
      creditsEarnedThisMonth: 37,
      totalCreditEntries: _creditEntries.length,
    );
  }

  @override
  Future<List<CreditEntryModel>> getCreditsHistory({
    int page = 1,
    int limit = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final startIndex = (page - 1) * limit;
    if (startIndex >= _creditEntries.length) {
      return [];
    }

    final endIndex = (startIndex + limit > _creditEntries.length)
        ? _creditEntries.length
        : startIndex + limit;

    return _creditEntries.sublist(startIndex, endIndex);
  }

  @override
  Future<int> calculateCreditsEarned(double sessionAmount) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    // Rule: 1 credit per $1 spent
    return sessionAmount.floor();
  }

  @override
  Future<PartnerStationModel?> checkCashbackEligibility(
      String stationId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _partnerStations
        .where((p) => p.stationId == stationId)
        .firstOrNull;
  }

  @override
  Future<CashbackModel?> applyCashback({
    required String sessionId,
    required String stationId,
    required double amount,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final partner = await checkCashbackEligibility(stationId);
    if (partner == null) {
      return null;
    }

    final cashbackAmount = amount * (partner.cashbackPercentage / 100);

    final cashback = CashbackModel(
      id: 'cb_${DateTime.now().millisecondsSinceEpoch}',
      sessionId: sessionId,
      stationId: stationId,
      stationName: partner.stationName,
      originalAmount: amount,
      cashbackPercentage: partner.cashbackPercentage,
      cashbackAmount: cashbackAmount,
      earnedAt: DateTime.now(),
      status: CashbackStatus.credited,
      creditedAt: DateTime.now(),
      isPartnerStation: true,
      partnerBadge: partner.partnerBadge,
    );

    _cashbackHistory.insert(0, cashback);

    // Update wallet balance
    _balance = _balance.copyWith(
      totalBalance: _balance.totalBalance + cashbackAmount,
      availableBalance: _balance.availableBalance + cashbackAmount,
      lastUpdated: DateTime.now(),
    );

    return cashback;
  }

  @override
  Future<List<CashbackModel>> getCashbackHistory({
    int page = 1,
    int limit = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final startIndex = (page - 1) * limit;
    if (startIndex >= _cashbackHistory.length) {
      return [];
    }

    final endIndex = (startIndex + limit > _cashbackHistory.length)
        ? _cashbackHistory.length
        : startIndex + limit;

    return _cashbackHistory.sublist(startIndex, endIndex);
  }
}


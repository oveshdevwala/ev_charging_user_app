/// File: lib/admin/features/wallets/repository/wallets_local_mock.dart
/// Purpose: Local mock data source for wallets with delay/error simulation
/// Belongs To: admin/features/wallets
/// Customization Guide:
/// - Replace with real API integration when backend is ready
library;

import 'dart:async';
import 'dart:math';

import '../../../core/constants/admin_assets.dart';
import '../../../core/utils/admin_helpers.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';

/// Paginated response structure.
class PaginatedWalletsResponse {
  const PaginatedWalletsResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
  });

  final List<WalletModel> items;
  final int total;
  final int page;
  final int perPage;
}

/// Paginated transactions response structure.
class PaginatedTransactionsResponse {
  const PaginatedTransactionsResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
  });

  final List<WalletTransactionModel> items;
  final int total;
  final int page;
  final int perPage;
}

/// Filter parameters for wallet queries.
class WalletFilters {
  const WalletFilters({
    this.status,
    this.currency,
    this.search,
    this.sortBy,
    this.order = 'asc',
  });

  final WalletStatus? status;
  final WalletCurrency? currency;
  final String? search;
  final String? sortBy; // 'balance', 'created_at'
  final String order; // 'asc', 'desc'
}

/// Local mock data source that loads wallets from bundled JSON.
class WalletsLocalMock {
  WalletsLocalMock({
    this.simulateError = false,
    this.artificialDelay = const Duration(milliseconds: 600),
  });

  bool simulateError;
  final Duration artificialDelay;

  List<WalletModel> _cache = [];
  final Map<String, List<WalletTransactionModel>> _transactionsCache = {};
  bool _isInitialized = false;
  final Random _random = Random();

  /// Load wallets with pagination and filters.
  Future<PaginatedWalletsResponse> fetchWallets({
    int page = 1,
    int perPage = 25,
    WalletFilters? filters,
    bool forceRefresh = false,
  }) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('wallets_fetch_failed');

    if (!_isInitialized || forceRefresh) {
      try {
        // Ensure path is correct - should be 'assets/dummy_data/admin/wallets.json'
        const assetPath = AdminAssets.jsonWallets;
        print('Loading wallets from: $assetPath');

        final data =
            await AdminHelpers.loadJsonAsset(assetPath) as List<dynamic>;
        _cache = data
            .map(
              (item) =>
                  WalletModel.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList();
        _isInitialized = true;
        print('Successfully loaded ${_cache.length} wallets from JSON');
      } catch (e) {
        // Fallback: Generate dummy wallets if asset loading fails
        print(
          'Warning: Failed to load wallets.json from ${AdminAssets.jsonWallets}, using fallback data: $e',
        );
        _cache = _generateFallbackWallets();
        _isInitialized = true;
        print('Generated ${_cache.length} fallback wallets');
      }
    }

    var filtered = List<WalletModel>.from(_cache);

    // Apply filters
    if (filters != null) {
      if (filters.status != null) {
        filtered = filtered.where((w) => w.status == filters.status).toList();
      }
      if (filters.currency != null) {
        filtered = filtered
            .where((w) => w.currency == filters.currency)
            .toList();
      }
      if (filters.search != null && filters.search!.isNotEmpty) {
        final query = filters.search!.toLowerCase();
        filtered = filtered.where((w) {
          return w.id.toLowerCase().contains(query) ||
              w.userName.toLowerCase().contains(query) ||
              w.userEmail.toLowerCase().contains(query) ||
              w.userId.toLowerCase().contains(query);
        }).toList();
      }

      // Apply sorting
      if (filters.sortBy != null) {
        filtered.sort((a, b) {
          var comparison = 0;
          switch (filters.sortBy) {
            case 'balance':
              comparison = a.balance.compareTo(b.balance);
              break;
            case 'created_at':
              comparison = a.createdAt.compareTo(b.createdAt);
              break;
            default:
              comparison = 0;
          }
          return filters.order == 'desc' ? -comparison : comparison;
        });
      }
    }

    final total = filtered.length;
    final start = (page - 1) * perPage;
    final end = start + perPage;
    final paginated = filtered.sublist(
      start.clamp(0, total),
      end.clamp(0, total),
    );

    return PaginatedWalletsResponse(
      items: paginated,
      total: total,
      page: page,
      perPage: perPage,
    );
  }

  /// Get a single wallet by id.
  Future<WalletModel> fetchWalletById(String id) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('wallet_detail_failed');

    if (!_isInitialized) {
      await fetchWallets();
    }

    final wallet = _cache.firstWhere(
      (w) => w.id == id,
      orElse: () => throw Exception('wallet_not_found'),
    );
    return wallet;
  }

  /// Load transactions for a wallet with pagination.
  Future<PaginatedTransactionsResponse> fetchTransactions({
    required String walletId,
    int page = 1,
    int perPage = 25,
  }) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('transactions_fetch_failed');

    if (!_transactionsCache.containsKey(walletId)) {
      // Generate dummy transactions if not cached
      final transactions = List.generate(
        8 + _random.nextInt(5),
        (index) => WalletTransactionModel(
          id: 'txn_${walletId}_${index + 1}',
          walletId: walletId,
          type: _random.nextBool()
              ? TransactionType.credit
              : TransactionType.debit,
          amount: _random.nextDouble() * 1000,
          currency: 'USD',
          memo: 'Transaction ${index + 1}',
          createdAt: DateTime.now().subtract(
            Duration(days: _random.nextInt(30)),
          ),
          actor: 'System',
        ),
      );
      _transactionsCache[walletId] = transactions;
    }

    final transactions = _transactionsCache[walletId]!;
    final total = transactions.length;
    final start = (page - 1) * perPage;
    final end = start + perPage;
    final paginated = transactions.sublist(
      start.clamp(0, total),
      end.clamp(0, total),
    );

    return PaginatedTransactionsResponse(
      items: paginated,
      total: total,
      page: page,
      perPage: perPage,
    );
  }

  /// Adjust wallet balance (credit/debit).
  Future<WalletModel> adjustBalance({
    required String walletId,
    required double amount,
    required String memo,
  }) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('adjust_balance_failed');

    final index = _cache.indexWhere((w) => w.id == walletId);
    if (index == -1) throw Exception('wallet_not_found');

    final wallet = _cache[index];
    final newBalance = wallet.balance + amount;
    final newAvailable = wallet.available + amount;

    // Add transaction to audit trail
    final transaction = WalletTransactionModel(
      id: 'txn_${walletId}_${DateTime.now().millisecondsSinceEpoch}',
      walletId: walletId,
      type: amount > 0 ? TransactionType.credit : TransactionType.adjust,
      amount: amount.abs(),
      currency: wallet.currencyCode,
      memo: memo,
      createdAt: DateTime.now(),
      actor: 'AdminTest',
    );

    if (!_transactionsCache.containsKey(walletId)) {
      _transactionsCache[walletId] = [];
    }
    _transactionsCache[walletId]!.insert(0, transaction);

    final updated = wallet.copyWith(
      balance: newBalance,
      available: newAvailable,
      lastActivity: DateTime.now(),
    );

    _cache[index] = updated;
    return updated;
  }

  /// Freeze a wallet.
  Future<WalletModel> freezeWallet(String walletId) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('freeze_wallet_failed');

    final index = _cache.indexWhere((w) => w.id == walletId);
    if (index == -1) throw Exception('wallet_not_found');

    final wallet = _cache[index];
    final updated = wallet.copyWith(
      status: WalletStatus.frozen,
      lastActivity: DateTime.now(),
    );

    // Add audit transaction
    final transaction = WalletTransactionModel(
      id: 'txn_${walletId}_${DateTime.now().millisecondsSinceEpoch}',
      walletId: walletId,
      type: TransactionType.adjust,
      amount: 0,
      currency: wallet.currencyCode,
      memo: 'Wallet frozen by admin',
      createdAt: DateTime.now(),
      actor: 'AdminTest',
    );

    if (!_transactionsCache.containsKey(walletId)) {
      _transactionsCache[walletId] = [];
    }
    _transactionsCache[walletId]!.insert(0, transaction);

    _cache[index] = updated;
    return updated;
  }

  /// Unfreeze a wallet.
  Future<WalletModel> unfreezeWallet(String walletId) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('unfreeze_wallet_failed');

    final index = _cache.indexWhere((w) => w.id == walletId);
    if (index == -1) throw Exception('wallet_not_found');

    final wallet = _cache[index];
    final updated = wallet.copyWith(
      status: WalletStatus.active,
      lastActivity: DateTime.now(),
    );

    // Add audit transaction
    final transaction = WalletTransactionModel(
      id: 'txn_${walletId}_${DateTime.now().millisecondsSinceEpoch}',
      walletId: walletId,
      type: TransactionType.adjust,
      amount: 0,
      currency: wallet.currencyCode,
      memo: 'Wallet unfrozen by admin',
      createdAt: DateTime.now(),
      actor: 'AdminTest',
    );

    if (!_transactionsCache.containsKey(walletId)) {
      _transactionsCache[walletId] = [];
    }
    _transactionsCache[walletId]!.insert(0, transaction);

    _cache[index] = updated;
    return updated;
  }

  /// Process a refund.
  Future<WalletModel> processRefund({
    required String walletId,
    required double amount,
    required String memo,
  }) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('refund_failed');

    final index = _cache.indexWhere((w) => w.id == walletId);
    if (index == -1) throw Exception('wallet_not_found');

    final wallet = _cache[index];
    final newBalance = wallet.balance + amount;
    final newAvailable = wallet.available + amount;

    // Add refund transaction
    final transaction = WalletTransactionModel(
      id: 'txn_${walletId}_${DateTime.now().millisecondsSinceEpoch}',
      walletId: walletId,
      type: TransactionType.refund,
      amount: amount,
      currency: wallet.currencyCode,
      memo: memo,
      createdAt: DateTime.now(),
      actor: 'AdminTest',
    );

    if (!_transactionsCache.containsKey(walletId)) {
      _transactionsCache[walletId] = [];
    }
    _transactionsCache[walletId]!.insert(0, transaction);

    final updated = wallet.copyWith(
      balance: newBalance,
      available: newAvailable,
      lastActivity: DateTime.now(),
    );

    _cache[index] = updated;
    return updated;
  }

  /// Generate fallback wallets if JSON asset fails to load.
  List<WalletModel> _generateFallbackWallets() {
    final now = DateTime.now();
    final currencies = [
      WalletCurrency.usd,
      WalletCurrency.inr,
      WalletCurrency.eur,
      WalletCurrency.gbp,
    ];
    final statuses = [WalletStatus.active, WalletStatus.frozen];
    final names = [
      'Alex Thompson',
      'Emily Davis',
      'James Wilson',
      'Sarah Martinez',
      'Michael Brown',
      'Jessica Taylor',
      'David Anderson',
      'Emma Garcia',
      'Daniel Rodriguez',
      'Olivia Lee',
    ];

    return List.generate(50, (index) {
      final currency = currencies[_random.nextInt(currencies.length)];
      final status = statuses[_random.nextInt(statuses.length)];
      final balance = (_random.nextDouble() * 10000).toStringAsFixed(2);
      final reserved = (_random.nextDouble() * 1000).toStringAsFixed(2);
      final available = (double.parse(balance) - double.parse(reserved))
          .toStringAsFixed(2);

      return WalletModel(
        id: 'wal_${(index + 1).toString().padLeft(3, '0')}',
        userId: 'usr_${(index + 1).toString().padLeft(3, '0')}',
        userName: names[index % names.length],
        userEmail: 'user${index + 1}@example.com',
        currency: currency,
        balance: double.parse(balance),
        reserved: double.parse(reserved),
        available: double.parse(available),
        status: status,
        createdAt: now.subtract(Duration(days: _random.nextInt(365))),
        lastActivity: now.subtract(Duration(days: _random.nextInt(30))),
      );
    });
  }
}

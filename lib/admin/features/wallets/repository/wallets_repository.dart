/// File: lib/admin/features/wallets/repository/wallets_repository.dart
/// Purpose: Repository abstraction for wallets data source
/// Belongs To: admin/features/wallets
/// Customization Guide:
/// - Toggle between mock and remote via [useMock] flag
/// - Replace with dependency injection when DI framework is added
library;

import '../models/wallet_model.dart';
import 'wallets_local_mock.dart';
import 'wallets_remote_data_source.dart';

/// Repository that abstracts between mock and remote data sources.
class WalletsRepository {
  WalletsRepository({
    bool useMock = true,
    WalletsLocalMock? mockDataSource,
    WalletsRemoteDataSource? remoteDataSource,
  }) : _useMock = useMock,
       _mockDataSource = mockDataSource ?? WalletsLocalMock(),
       _remoteDataSource = remoteDataSource ?? WalletsRemoteDataSource();

  final bool _useMock;
  final WalletsLocalMock _mockDataSource;
  final WalletsRemoteDataSource _remoteDataSource;

  /// Fetch wallets with pagination and filters.
  Future<PaginatedWalletsResponse> fetchWallets({
    int page = 1,
    int perPage = 25,
    WalletFilters? filters,
    bool forceRefresh = false,
  }) async {
    if (_useMock) {
      return _mockDataSource.fetchWallets(
        page: page,
        perPage: perPage,
        filters: filters,
        forceRefresh: forceRefresh,
      );
    } else {
      return _remoteDataSource.fetchWallets(
        page: page,
        perPage: perPage,
        filters: filters,
      );
    }
  }

  /// Fetch single wallet by id.
  Future<WalletModel> fetchWalletById(String id) async {
    if (_useMock) {
      return _mockDataSource.fetchWalletById(id);
    } else {
      return _remoteDataSource.fetchWalletById(id);
    }
  }

  /// Fetch transactions for a wallet.
  Future<PaginatedTransactionsResponse> fetchTransactions({
    required String walletId,
    int page = 1,
    int perPage = 25,
  }) async {
    if (_useMock) {
      return _mockDataSource.fetchTransactions(
        walletId: walletId,
        page: page,
        perPage: perPage,
      );
    } else {
      return _remoteDataSource.fetchTransactions(
        walletId: walletId,
        page: page,
        perPage: perPage,
      );
    }
  }

  /// Adjust wallet balance.
  Future<WalletModel> adjustBalance({
    required String walletId,
    required double amount,
    required String memo,
  }) async {
    if (_useMock) {
      return _mockDataSource.adjustBalance(
        walletId: walletId,
        amount: amount,
        memo: memo,
      );
    } else {
      return _remoteDataSource.adjustBalance(
        walletId: walletId,
        amount: amount,
        memo: memo,
      );
    }
  }

  /// Freeze wallet.
  Future<WalletModel> freezeWallet(String walletId) async {
    if (_useMock) {
      return _mockDataSource.freezeWallet(walletId);
    } else {
      return _remoteDataSource.freezeWallet(walletId);
    }
  }

  /// Unfreeze wallet.
  Future<WalletModel> unfreezeWallet(String walletId) async {
    if (_useMock) {
      return _mockDataSource.unfreezeWallet(walletId);
    } else {
      return _remoteDataSource.unfreezeWallet(walletId);
    }
  }

  /// Process refund.
  Future<WalletModel> processRefund({
    required String walletId,
    required double amount,
    required String memo,
  }) async {
    if (_useMock) {
      return _mockDataSource.processRefund(
        walletId: walletId,
        amount: amount,
        memo: memo,
      );
    } else {
      return _remoteDataSource.processRefund(
        walletId: walletId,
        amount: amount,
        memo: memo,
      );
    }
  }
}

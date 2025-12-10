/// File: lib/admin/features/wallets/wallets_bindings.dart
/// Purpose: Helper factory for wiring blocs/repository for wallets module
/// Belongs To: admin/features/wallets
/// Customization Guide:
/// - Swap repository with API implementation while preserving factory helpers
library;

import 'bloc/wallet_detail_bloc.dart';
import 'bloc/wallets_bloc.dart';
import 'repository/wallets_repository.dart';

/// Simple binding helper to keep bloc creation consistent across routes.
class WalletsBindings {
  WalletsBindings({WalletsRepository? repository})
      : repository = repository ?? WalletsRepository();

  /// Shared singleton for module wiring.
  static final WalletsBindings instance = WalletsBindings();

  final WalletsRepository repository;

  WalletsBloc walletsBloc() => WalletsBloc(repository: repository);

  WalletDetailBloc walletDetailBloc() =>
      WalletDetailBloc(repository: repository);
}

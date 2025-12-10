/// File: lib/admin/features/wallets/wallets.dart
/// Purpose: Barrel exports for wallets management feature
/// Belongs To: admin/features/wallets
/// Customization Guide:
/// - Extend exports as the wallets module grows
/// - Keep public API surface minimal for consumers
library;

export 'bloc/wallet_detail_bloc.dart';
export 'bloc/wallets_bloc.dart';
export 'models/wallet_model.dart';
export 'models/wallet_transaction_model.dart';
export 'repository/wallets_local_mock.dart';
export 'repository/wallets_remote_data_source.dart';
export 'repository/wallets_repository.dart';
export 'views/wallet_detail_page.dart';
export 'views/wallets_list_page.dart';
export 'views/widgets/wallet_actions_bar.dart';
// export 'views/widgets/wallet_filters.dart';
export 'views/widgets/wallet_transaction_item.dart';
export 'views/widgets/wallets_table.dart';
export 'wallets_bindings.dart';

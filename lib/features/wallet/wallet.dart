/// File: lib/features/wallet/wallet.dart
/// Purpose: Barrel file for complete wallet feature
/// Belongs To: wallet feature
/// 
/// ## Feature Overview:
/// The wallet feature provides complete wallet management including:
/// - Wallet balance display with glassmorphism UI
/// - Transaction history with filtering
/// - Wallet recharge with payment gateway placeholder
/// - Promo code application and validation
/// - Charging credits ledger and earning
/// - Cashback tracking for partner stations
/// 
/// ## Architecture:
/// ```
/// wallet/
/// ├── data/
/// │   ├── models/          # Data models (WalletBalance, Transaction, etc.)
/// │   └── repositories/    # Repository implementations
/// ├── presentation/
/// │   ├── blocs/           # WalletBloc, RechargeCubit
/// │   ├── screens/         # WalletPage, RechargePage
/// │   └── widgets/         # Reusable wallet widgets
/// └── wallet.dart          # This barrel file
/// ```
/// 
/// ## Usage:
/// ```dart
/// // Navigate to wallet
/// context.push(AppRoutes.wallet.path);
/// 
/// // Navigate to recharge
/// context.push(AppRoutes.walletRecharge.path);
/// ```
library;

export 'data/data.dart';
export 'presentation/presentation.dart';


# Wallets Management Feature - Installation Guide

## Overview

The Wallets Management feature provides comprehensive wallet administration capabilities including:
- Wallet list with pagination, search, and filtering
- Wallet detail view with transaction history
- Balance adjustment (credit/debit)
- Freeze/unfreeze wallet operations
- Manual refund processing
- Bulk actions (freeze/unfreeze multiple wallets)
- CSV export (stub implementation)

## Architecture

The feature follows the Admin panel's MVVM + BLoC pattern:
- **Models**: `WalletModel`, `WalletTransactionModel`
- **Repository**: `WalletsRepository` (abstracts mock/remote data sources)
- **BLoC**: `WalletsBloc` (list), `WalletDetailBloc` (detail)
- **Views**: `WalletsListPage`, `WalletDetailPage`
- **Widgets**: Reusable components for table, filters, actions bar, transaction items

## File Structure

```
lib/admin/features/wallets/
├── bloc/
│   ├── wallets_bloc.dart
│   ├── wallets_event.dart
│   ├── wallets_state.dart
│   ├── wallet_detail_bloc.dart
│   ├── wallet_detail_event.dart
│   └── wallet_detail_state.dart
├── models/
│   ├── wallet_model.dart
│   └── wallet_transaction_model.dart
├── repository/
│   ├── wallets_repository.dart
│   ├── wallets_local_mock.dart
│   └── wallets_remote_data_source.dart
├── views/
│   ├── wallets_list_page.dart
│   ├── wallet_detail_page.dart
│   └── widgets/
│       ├── wallets_table.dart
│       ├── wallet_filters.dart
│       ├── wallet_actions_bar.dart
│       └── wallet_transaction_item.dart
├── wallets_bindings.dart
└── wallets.dart (barrel exports)
```

## Setup Instructions

### 1. Dummy Data

The feature uses dummy JSON data located at:
```
assets/dummy_data/admin/wallets.json
```

This file contains 50 wallet records with varied currencies (USD, INR, EUR, GBP), statuses (active/frozen), and realistic balances.

### 2. Route Registration

The wallets route is already registered in `lib/admin/routes/admin_routes.dart`:

```dart
enum AdminRoutes {
  // ...
  wallets,
  walletDetail,
  // ...
}
```

The route path is `/admin/wallets` and is handled by `AdminMainPage` via `IndexedStack` (tab-based navigation).

### 3. AdminMainPage Integration

The `WalletsListPage` is already integrated into `AdminMainPage`:

```dart
// lib/admin/features/admin_main/view/admin_main_page.dart
final List<Widget> _views = [
  // ...
  PaymentsListView(),
  const WalletsListPage(), // ← Already added
  // ...
];
```

### 4. Toggle Mock vs Remote Data Source

By default, the feature uses mock data. To switch to remote API:

**Option 1: Modify WalletsBindings**

```dart
// lib/admin/features/wallets/wallets_bindings.dart
class WalletsBindings {
  WalletsBindings({WalletsRepository? repository})
      : repository = repository ?? WalletsRepository(useMock: false); // ← Change to false
  // ...
}
```

**Option 2: Environment Config (Recommended)**

Create an environment config file:

```dart
// lib/core/config/environment_config.dart
class EnvironmentConfig {
  static const bool useMockWallets = true; // Set to false for production
}
```

Then update `WalletsBindings`:

```dart
WalletsBindings({WalletsRepository? repository})
    : repository = repository ?? WalletsRepository(
        useMock: EnvironmentConfig.useMockWallets,
      );
```

### 5. Remote API Implementation

When ready to integrate real API, implement `WalletsRemoteDataSource`:

```dart
// lib/admin/features/wallets/repository/wallets_remote_data_source.dart

class WalletsRemoteDataSource {
  final Dio _dio; // or HttpClient
  
  Future<PaginatedWalletsResponse> fetchWallets({
    int page = 1,
    int perPage = 25,
    WalletFilters? filters,
  }) async {
    final response = await _dio.get('/admin/wallets', queryParameters: {
      'page': page,
      'per_page': perPage,
      'status': filters?.status?.name,
      'currency': filters?.currency?.name,
      'search': filters?.search,
      'sort_by': filters?.sortBy,
      'order': filters?.order,
    });
    
    return PaginatedWalletsResponse(
      items: (response.data['items'] as List)
          .map((item) => WalletModel.fromJson(item))
          .toList(),
      total: response.data['total'] as int,
      page: response.data['page'] as int,
      perPage: response.data['per_page'] as int,
    );
  }
  
  // Implement other methods...
}
```

## Usage

### Opening Wallets List

Navigate to `/admin/wallets` or click "Wallets" in the admin sidebar. The list page will:
- Load wallets with pagination (25 per page by default)
- Support search by user email/name/ID
- Filter by status (active/frozen) and currency
- Sort by balance or created_at
- Select wallets for bulk actions

### Opening Wallet Detail

Click "View Details" on any wallet row to open the detail modal. The detail page shows:
- Wallet summary (balance, reserved, available)
- Action buttons (adjust balance, freeze/unfreeze, refund)
- Transaction history with pagination

### Adjusting Balance

1. Click "Adjust Balance" button
2. Enter amount (positive for credit, negative for debit)
3. Enter memo/reason
4. Type "CONFIRM" to proceed
5. Click "Save"

The adjustment is recorded in the transaction history with actor "AdminTest".

### Freeze/Unfreeze Wallet

1. Click "Freeze Wallet" or "Unfreeze Wallet"
2. Type "CONFIRM" in the confirmation dialog
3. Click "Save"

The action is recorded in the transaction history.

### Bulk Actions

1. Select wallets using checkboxes
2. Use the actions bar to:
   - Freeze selected wallets
   - Unfreeze selected wallets
   - Export CSV (stub - needs implementation)

## Features

### ✅ Implemented

- [x] Wallet list with pagination
- [x] Search by user email/name/ID
- [x] Filter by status and currency
- [x] Sort by balance or created_at
- [x] Wallet selection (single/bulk)
- [x] Wallet detail modal
- [x] Transaction history with pagination
- [x] Balance adjustment (credit/debit)
- [x] Freeze/unfreeze wallet
- [x] Manual refund
- [x] Bulk freeze/unfreeze
- [x] Audit trail (all actions recorded)
- [x] Confirmation dialogs with "CONFIRM" requirement
- [x] Loading states
- [x] Error handling
- [x] Empty states
- [x] Responsive design (mobile/tablet/desktop)

### 🚧 Stubs (TODO)

- [ ] CSV export implementation
- [ ] Remote API integration
- [ ] Retry logic with exponential backoff
- [ ] Real-time updates (WebSocket)
- [ ] Advanced filters (date range, amount range)
- [ ] Wallet statistics/charts

## Testing

Run the app:

```bash
flutter pub get
flutter run
```

Navigate to `/admin/wallets` to see the wallets list.

## Troubleshooting

### Issue: "Failed to load JSON from assets/dummy_data/admin/wallets.json"

**Solution**: Ensure `wallets.json` exists in `assets/dummy_data/admin/` and is registered in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/dummy_data/admin/
```

### Issue: BlocProvider errors

**Solution**: Ensure `WalletsListPage` wraps its BLoC with `BlocProvider` (already implemented). For detail page, ensure it's opened via `AdminModalSheet.show()` with proper BLoC provider.

### Issue: Transactions not showing

**Solution**: Transactions are generated dynamically in `WalletsLocalMock.fetchTransactions()`. They are created on-demand when viewing wallet detail.

## Customization

### Adding New Currency

1. Add enum value in `WalletModel`:
```dart
enum WalletCurrency { usd, inr, eur, gbp, cad } // Add CAD
```

2. Update `currencySymbol` and `currencyCode` getters
3. Update `_currencyFromString` helper
4. Add to filter dropdown in `WalletFilters`

### Adding New Transaction Type

1. Add enum value in `WalletTransactionModel`:
```dart
enum TransactionType { credit, debit, refund, adjust, transfer }
```

2. Update `_typeFromString` helper
3. Update `_getTypeLabel` in `WalletTransactionItem`

### Customizing Pagination

Modify default `perPage` in `WalletsListPage`:

```dart
const LoadWallets(page: 1, perPage: 50) // Change from 25 to 50
```

## Support

For issues or questions, refer to:
- Admin panel architecture: `.cursorrules`
- BLoC patterns: `lib/admin/features/payments/` (reference implementation)
- Widget patterns: `lib/admin/core/widgets/`

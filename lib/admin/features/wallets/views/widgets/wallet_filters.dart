/// File: lib/admin/features/wallets/views/widgets/wallet_filters.dart
/// Purpose: Filter widget for wallets list
/// Belongs To: admin/features/wallets
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/admin_strings.dart';
import '../../../../core/widgets/widgets.dart';
import '../../models/wallet_model.dart';

/// Filter widget for wallets.
class WalletFilters extends StatefulWidget {
  const WalletFilters({
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.onReset,
    super.key,
    this.status,
    this.currency,
    this.searchQuery = '',
  });

  final WalletStatus? status;
  final WalletCurrency? currency;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final void Function(
    WalletStatus? status,
    WalletCurrency? currency,
    String? sortBy,
    String? order,
  )
  onFilterChanged;
  final VoidCallback onReset;

  @override
  State<WalletFilters> createState() => _WalletFiltersState();
}

class _WalletFiltersState extends State<WalletFilters> {
  late TextEditingController _searchController;
  String? _sortBy;
  String _order = 'asc';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(WalletFilters oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      _searchController.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _getFilterCount() {
    var count = 0;
    if (widget.status != null) count++;
    if (widget.currency != null) count++;
    if (_sortBy != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return AdminResponsiveFilterBar(
      searchController: _searchController,
      searchHint: AdminStrings.walletsSearchHint,
      onSearchChanged: widget.onSearchChanged,
      onReset: () {
        setState(() {
          _sortBy = null;
          _order = 'asc';
        });
        widget.onReset();
      },
      filterCount: _getFilterCount(),
      filterItems: [
        AdminFilterItem<WalletStatus?>(
          id: 'status',
          label: AdminStrings.walletsFilterStatus,
          value: widget.status,
          width: 150.w,
          items: const [
            DropdownMenuItem<WalletStatus?>(child: Text('All Status')),
            DropdownMenuItem<WalletStatus?>(
              value: WalletStatus.active,
              child: Text('Active'),
            ),
            DropdownMenuItem<WalletStatus?>(
              value: WalletStatus.frozen,
              child: Text('Frozen'),
            ),
          ],
          onChanged: (value) =>
              widget.onFilterChanged(value, widget.currency, _sortBy, _order),
        ),
        AdminFilterItem<WalletCurrency?>(
          id: 'currency',
          label: AdminStrings.walletsFilterCurrency,
          value: widget.currency,
          width: 150.w,
          items: const [
            DropdownMenuItem<WalletCurrency?>(child: Text('All Currency')),
            DropdownMenuItem<WalletCurrency?>(
              value: WalletCurrency.usd,
              child: Text('USD'),
            ),
            DropdownMenuItem<WalletCurrency?>(
              value: WalletCurrency.inr,
              child: Text('INR'),
            ),
            DropdownMenuItem<WalletCurrency?>(
              value: WalletCurrency.eur,
              child: Text('EUR'),
            ),
            DropdownMenuItem<WalletCurrency?>(
              value: WalletCurrency.gbp,
              child: Text('GBP'),
            ),
          ],
          onChanged: (value) =>
              widget.onFilterChanged(widget.status, value, _sortBy, _order),
        ),
        AdminFilterItem<String?>(
          id: 'sortBy',
          label: 'Sort by',
          value: _sortBy,
          width: 150.w,
          items: const [
            DropdownMenuItem<String?>(child: Text('None')),
            DropdownMenuItem<String?>(value: 'balance', child: Text('Balance')),
            DropdownMenuItem<String?>(
              value: 'created_at',
              child: Text('Created At'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _sortBy = value;
            });
            widget.onFilterChanged(
              widget.status,
              widget.currency,
              value,
              _order,
            );
          },
        ),
      ],
    );
  }
}

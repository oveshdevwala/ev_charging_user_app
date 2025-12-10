/// File: lib/admin/features/offers/views/widgets/offer_filters.dart
/// Purpose: Filter widget for offers list with responsive design
/// Belongs To: admin/features/offers
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/admin_strings.dart';
import '../../../../core/widgets/widgets.dart';
import '../../models/offer_model.dart';

/// Filter widget for offers.
class OfferFilters extends StatefulWidget {
  const OfferFilters({
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.onReset,
    super.key,
    this.status,
    this.discountType,
    this.searchQuery = '',
  });

  final OfferStatus? status;
  final DiscountType? discountType;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final void Function(
    OfferStatus? status,
    DiscountType? discountType,
    String? sortBy,
    String? order,
  )
  onFilterChanged;
  final VoidCallback onReset;

  @override
  State<OfferFilters> createState() => _OfferFiltersState();
}

class _OfferFiltersState extends State<OfferFilters> {
  late TextEditingController _searchController;
  String? _sortBy;
  String _order = 'asc';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(OfferFilters oldWidget) {
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
    if (widget.discountType != null) count++;
    if (_sortBy != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return AdminResponsiveFilterBar(
      searchController: _searchController,
      searchHint: AdminStrings.offersSearchHint,
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
        AdminFilterItem<OfferStatus?>(
          id: 'status',
          label: AdminStrings.filterStatus,
          value: widget.status,
          width: 150.w,
          items: const [
            DropdownMenuItem<OfferStatus?>(child: Text('All Status')),
            DropdownMenuItem<OfferStatus?>(
              value: OfferStatus.active,
              child: Text('Active'),
            ),
            DropdownMenuItem<OfferStatus?>(
              value: OfferStatus.inactive,
              child: Text('Inactive'),
            ),
            DropdownMenuItem<OfferStatus?>(
              value: OfferStatus.scheduled,
              child: Text('Scheduled'),
            ),
            DropdownMenuItem<OfferStatus?>(
              value: OfferStatus.expired,
              child: Text('Expired'),
            ),
          ],
          onChanged: (value) => widget.onFilterChanged(
            value,
            widget.discountType,
            _sortBy,
            _order,
          ),
        ),
        AdminFilterItem<DiscountType?>(
          id: 'discountType',
          label: AdminStrings.offersDiscountType,
          value: widget.discountType,
          width: 160.w,
          items: const [
            DropdownMenuItem<DiscountType?>(child: Text('All Types')),
            DropdownMenuItem<DiscountType?>(
              value: DiscountType.percentage,
              child: Text('Percentage'),
            ),
            DropdownMenuItem<DiscountType?>(
              value: DiscountType.fixed,
              child: Text('Fixed Amount'),
            ),
            DropdownMenuItem<DiscountType?>(
              value: DiscountType.freeEnergy,
              child: Text('Free Energy'),
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
            DropdownMenuItem<String?>(
              value: 'created_at',
              child: Text('Created At'),
            ),
            DropdownMenuItem<String?>(
              value: 'valid_until',
              child: Text('Valid Until'),
            ),
            DropdownMenuItem<String?>(
              value: 'discount_value',
              child: Text('Discount Value'),
            ),
            DropdownMenuItem<String?>(
              value: 'current_uses',
              child: Text('Usage Count'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _sortBy = value;
            });
            widget.onFilterChanged(
              widget.status,
              widget.discountType,
              value,
              _order,
            );
          },
        ),
      ],
    );
  }
}

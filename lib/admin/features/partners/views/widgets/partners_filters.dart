/// File: lib/admin/features/partners/views/widgets/partners_filters.dart
/// Purpose: Filter widget for partners list
/// Belongs To: admin/features/partners
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/admin_strings.dart';
import '../../../../core/widgets/widgets.dart';
import '../../models/models.dart';

/// Partners filter widget.
class PartnersFilters extends StatefulWidget {
  const PartnersFilters({
    required this.status,
    required this.type,
    required this.country,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.onReset,
    super.key,
  });

  final PartnerStatus? status;
  final PartnerType? type;
  final String? country;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final void Function(PartnerStatus? status, PartnerType? type, String? country)
  onFilterChanged;
  final VoidCallback onReset;

  @override
  State<PartnersFilters> createState() => _PartnersFiltersState();
}

class _PartnersFiltersState extends State<PartnersFilters> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(PartnersFilters oldWidget) {
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
    if (widget.type != null) count++;
    if (widget.country != null) count++;
    return count;
  }

  String _getStatusLabel(PartnerStatus status) {
    switch (status) {
      case PartnerStatus.pending:
        return AdminStrings.partnersStatusPending;
      case PartnerStatus.active:
        return AdminStrings.partnersStatusActive;
      case PartnerStatus.suspended:
        return AdminStrings.partnersStatusSuspended;
      case PartnerStatus.rejected:
        return AdminStrings.partnersStatusRejected;
    }
  }

  String _getTypeLabel(PartnerType type) {
    switch (type) {
      case PartnerType.owner:
        return AdminStrings.partnersTypeOwner;
      case PartnerType.operator:
        return AdminStrings.partnersTypeOperator;
      case PartnerType.reseller:
        return AdminStrings.partnersTypeReseller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: EdgeInsets.all(16.w),
      child: AdminResponsiveFilterBar(
        searchController: _searchController,
        searchHint: AdminStrings.partnersSearchHint,
        onSearchChanged: widget.onSearchChanged,
        onReset: widget.onReset,
        filterCount: _getFilterCount(),
        filterItems: [
          AdminFilterItem<PartnerStatus?>(
            id: 'status',
            label: AdminStrings.partnersFilterStatus,
            value: widget.status,
            width: 140.w,
            items: [
              const DropdownMenuItem<PartnerStatus?>(child: Text('All')),
              ...PartnerStatus.values.map(
                (s) => DropdownMenuItem<PartnerStatus?>(
                  value: s,
                  child: Text(_getStatusLabel(s)),
                ),
              ),
            ],
            onChanged: (value) {
              widget.onFilterChanged(value, widget.type, widget.country);
            },
          ),
          AdminFilterItem<PartnerType?>(
            id: 'type',
            label: AdminStrings.partnersFilterType,
            value: widget.type,
            width: 140.w,
            items: [
              const DropdownMenuItem<PartnerType?>(child: Text('All')),
              ...PartnerType.values.map(
                (t) => DropdownMenuItem<PartnerType?>(
                  value: t,
                  child: Text(_getTypeLabel(t)),
                ),
              ),
            ],
            onChanged: (value) {
              widget.onFilterChanged(widget.status, value, widget.country);
            },
          ),
          AdminFilterItem<String?>(
            id: 'country',
            label: AdminStrings.partnersFilterCountry,
            value: widget.country,
            width: 140.w,
            items: const [
              DropdownMenuItem<String?>(child: Text('All')),
              DropdownMenuItem<String?>(value: 'IN', child: Text('India')),
              DropdownMenuItem<String?>(value: 'US', child: Text('USA')),
              DropdownMenuItem<String?>(value: 'UK', child: Text('UK')),
              DropdownMenuItem<String?>(value: 'DE', child: Text('Germany')),
            ],
            onChanged: (value) {
              widget.onFilterChanged(widget.status, widget.type, value);
            },
          ),
        ],
      ),
    );
  }
}

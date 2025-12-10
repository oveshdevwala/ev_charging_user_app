/// File: lib/admin/features/partners/bloc/partners_event.dart
/// Purpose: Events for partners list BLoC
/// Belongs To: admin/features/partners
library;

import 'package:equatable/equatable.dart';

import '../repository/partners_requests.dart';

/// Base class for partners events.
abstract class PartnersEvent extends Equatable {
  const PartnersEvent();

  @override
  List<Object?> get props => [];
}

/// Load partners with pagination and filters.
class LoadPartners extends PartnersEvent {
  const LoadPartners({
    this.page = 1,
    this.perPage = 25,
    this.filters,
    this.sortBy,
    this.order = 'desc',
    this.forceRefresh = false,
  });

  final int page;
  final int perPage;
  final PartnersFilters? filters;
  final String? sortBy;
  final String order;
  final bool forceRefresh;

  @override
  List<Object?> get props => [
    page,
    perPage,
    filters,
    sortBy,
    order,
    forceRefresh,
  ];
}

/// Search partners by query.
class SearchPartners extends PartnersEvent {
  const SearchPartners(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Filter partners.
class FilterPartners extends PartnersEvent {
  const FilterPartners(this.filters);

  final PartnersFilters filters;

  @override
  List<Object?> get props => [filters];
}

/// Sort partners.
class SortPartners extends PartnersEvent {
  const SortPartners({required this.columnId, required this.ascending});

  final String columnId;
  final bool ascending;

  @override
  List<Object?> get props => [columnId, ascending];
}

/// Change current page.
class ChangePage extends PartnersEvent {
  const ChangePage(this.page);

  final int page;

  @override
  List<Object?> get props => [page];
}

/// Change page size.
class ChangePageSize extends PartnersEvent {
  const ChangePageSize(this.perPage);

  final int perPage;

  @override
  List<Object?> get props => [perPage];
}

/// Toggle partner selection.
class ToggleSelectPartner extends PartnersEvent {
  const ToggleSelectPartner(this.partnerId);

  final String partnerId;

  @override
  List<Object?> get props => [partnerId];
}

/// Select all partners.
class SelectAllPartners extends PartnersEvent {
  const SelectAllPartners();
}

/// Clear partner selection.
class ClearSelection extends PartnersEvent {
  const ClearSelection();
}

/// Bulk approve partners.
class BulkApprovePartners extends PartnersEvent {
  const BulkApprovePartners(this.partnerIds);

  final List<String> partnerIds;

  @override
  List<Object?> get props => [partnerIds];
}

/// Bulk reject partners.
class BulkRejectPartners extends PartnersEvent {
  const BulkRejectPartners({required this.partnerIds, required this.reason});

  final List<String> partnerIds;
  final String reason;

  @override
  List<Object?> get props => [partnerIds, reason];
}

/// Refresh partners list.
class RefreshPartners extends PartnersEvent {
  const RefreshPartners();
}

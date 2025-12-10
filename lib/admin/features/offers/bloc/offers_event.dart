/// File: lib/admin/features/offers/bloc/offers_event.dart
/// Purpose: Events for offers list BLoC
/// Belongs To: admin/features/offers
library;

import 'package:equatable/equatable.dart';

import '../repository/offers_local_mock.dart';

/// Base class for offers events.
abstract class OffersEvent extends Equatable {
  const OffersEvent();

  @override
  List<Object?> get props => [];
}

/// Load offers with pagination and filters.
class LoadOffers extends OffersEvent {
  const LoadOffers({
    this.page = 1,
    this.perPage = 25,
    this.filters,
    this.forceRefresh = false,
  });

  final int page;
  final int perPage;
  final OfferFilters? filters;
  final bool forceRefresh;

  @override
  List<Object?> get props => [page, perPage, filters, forceRefresh];
}

/// Search offers by query.
class SearchOffers extends OffersEvent {
  const SearchOffers(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Change current page.
class ChangePage extends OffersEvent {
  const ChangePage(this.page);

  final int page;

  @override
  List<Object?> get props => [page];
}

/// Change page size.
class ChangePageSize extends OffersEvent {
  const ChangePageSize(this.perPage);

  final int perPage;

  @override
  List<Object?> get props => [perPage];
}

/// Toggle offer selection.
class ToggleSelectOffer extends OffersEvent {
  const ToggleSelectOffer(this.offerId);

  final String offerId;

  @override
  List<Object?> get props => [offerId];
}

/// Select all offers.
class SelectAllOffers extends OffersEvent {
  const SelectAllOffers();
}

/// Clear offer selection.
class ClearSelection extends OffersEvent {
  const ClearSelection();
}

/// Apply filters.
class ApplyFilters extends OffersEvent {
  const ApplyFilters(this.filters);

  final OfferFilters filters;

  @override
  List<Object?> get props => [filters];
}

/// Reset filters.
class ResetFilters extends OffersEvent {
  const ResetFilters();
}

/// Bulk action on selected offers.
class BulkAction extends OffersEvent {
  const BulkAction({required this.action, required this.offerIds});

  final BulkActionType action;
  final List<String> offerIds;

  @override
  List<Object?> get props => [action, offerIds];
}

/// Bulk action types.
enum BulkActionType { activate, deactivate, delete, export }

/// Refresh offers list.
class RefreshOffers extends OffersEvent {
  const RefreshOffers();
}

/// Delete single offer from list.
class DeleteOfferFromList extends OffersEvent {
  const DeleteOfferFromList(this.offerId);

  final String offerId;

  @override
  List<Object?> get props => [offerId];
}

/// Activate single offer from list.
class ActivateOfferFromList extends OffersEvent {
  const ActivateOfferFromList(this.offerId);

  final String offerId;

  @override
  List<Object?> get props => [offerId];
}

/// Deactivate single offer from list.
class DeactivateOfferFromList extends OffersEvent {
  const DeactivateOfferFromList(this.offerId);

  final String offerId;

  @override
  List<Object?> get props => [offerId];
}

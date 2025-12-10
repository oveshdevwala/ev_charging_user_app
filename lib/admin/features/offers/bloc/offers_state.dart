/// File: lib/admin/features/offers/bloc/offers_state.dart
/// Purpose: State definitions for offers list BLoC
/// Belongs To: admin/features/offers
library;

import 'package:equatable/equatable.dart';

import '../models/offer_model.dart';
import '../repository/offers_local_mock.dart';

/// Lifecycle status for offers list.
enum OffersStatus { initial, loading, loaded, error, actionSuccess }

/// State for [OffersBloc].
class OffersState extends Equatable {
  const OffersState({
    this.status = OffersStatus.initial,
    this.items = const [],
    this.total = 0,
    this.page = 1,
    this.perPage = 25,
    this.selectedIds = const {},
    this.filters,
    this.searchQuery = '',
    this.error,
    this.successMessage,
  });

  final OffersStatus status;
  final List<OfferModel> items;
  final int total;
  final int page;
  final int perPage;
  final Set<String> selectedIds;
  final OfferFilters? filters;
  final String searchQuery;
  final String? error;
  final String? successMessage;

  bool get isLoading => status == OffersStatus.loading;
  bool get hasSelection => selectedIds.isNotEmpty;
  int get totalPages => (total / perPage).ceil();
  bool get hasNextPage => page < totalPages;
  bool get hasPreviousPage => page > 1;

  OffersState copyWith({
    OffersStatus? status,
    List<OfferModel>? items,
    int? total,
    int? page,
    int? perPage,
    Set<String>? selectedIds,
    OfferFilters? filters,
    String? searchQuery,
    String? error,
    String? successMessage,
  }) {
    return OffersState(
      status: status ?? this.status,
      items: items ?? this.items,
      total: total ?? this.total,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      selectedIds: selectedIds ?? this.selectedIds,
      filters: filters ?? this.filters,
      searchQuery: searchQuery ?? this.searchQuery,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        total,
        page,
        perPage,
        selectedIds,
        filters,
        searchQuery,
        error,
        successMessage,
      ];
}

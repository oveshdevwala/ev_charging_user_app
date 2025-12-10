/// File: lib/admin/features/partners/bloc/partners_state.dart
/// Purpose: State definitions for partners list BLoC
/// Belongs To: admin/features/partners
library;

import 'package:equatable/equatable.dart';

import '../models/models.dart';
import '../repository/partners_requests.dart';

/// Lifecycle status for partners list.
enum PartnersStatus { initial, loading, loaded, error, actionSuccess }

/// Sort state.
class SortState {
  const SortState({this.columnId, this.ascending = true});

  final String? columnId;
  final bool ascending;

  SortState copyWith({String? columnId, bool? ascending}) {
    return SortState(
      columnId: columnId ?? this.columnId,
      ascending: ascending ?? this.ascending,
    );
  }
}

/// State for [PartnersBloc].
class PartnersState extends Equatable {
  const PartnersState({
    this.status = PartnersStatus.initial,
    this.partners = const [],
    this.total = 0,
    this.page = 1,
    this.perPage = 25,
    this.selectedPartnerIds = const {},
    this.filters,
    this.sortState,
    this.searchQuery = '',
    this.error,
    this.successMessage,
    this.isRefreshing = false,
  });

  final PartnersStatus status;
  final List<PartnerModel> partners;
  final int total;
  final int page;
  final int perPage;
  final Set<String> selectedPartnerIds;
  final PartnersFilters? filters;
  final SortState? sortState;
  final String searchQuery;
  final String? error;
  final String? successMessage;
  final bool isRefreshing;

  bool get isLoading => status == PartnersStatus.loading;
  bool get hasSelection => selectedPartnerIds.isNotEmpty;
  int get totalPages => perPage > 0 ? (total / perPage).ceil() : 0;
  bool get hasNextPage => page < totalPages;
  bool get hasPreviousPage => page > 1;

  PartnersState copyWith({
    PartnersStatus? status,
    List<PartnerModel>? partners,
    int? total,
    int? page,
    int? perPage,
    Set<String>? selectedPartnerIds,
    PartnersFilters? filters,
    SortState? sortState,
    String? searchQuery,
    String? error,
    String? successMessage,
    bool? isRefreshing,
  }) {
    return PartnersState(
      status: status ?? this.status,
      partners: partners ?? this.partners,
      total: total ?? this.total,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      selectedPartnerIds: selectedPartnerIds ?? this.selectedPartnerIds,
      filters: filters ?? this.filters,
      sortState: sortState ?? this.sortState,
      searchQuery: searchQuery ?? this.searchQuery,
      error: error,
      successMessage: successMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    status,
    partners,
    total,
    page,
    perPage,
    selectedPartnerIds,
    filters,
    sortState,
    searchQuery,
    error,
    successMessage,
    isRefreshing,
  ];
}

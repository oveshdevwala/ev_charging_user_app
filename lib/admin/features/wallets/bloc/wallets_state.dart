/// File: lib/admin/features/wallets/bloc/wallets_state.dart
/// Purpose: State definitions for wallets list BLoC
/// Belongs To: admin/features/wallets
library;

import 'package:equatable/equatable.dart';

import '../models/wallet_model.dart';
import '../repository/wallets_local_mock.dart';

/// Lifecycle status for wallets list.
enum WalletsStatus { initial, loading, loaded, error, actionSuccess }

/// State for [WalletsBloc].
class WalletsState extends Equatable {
  const WalletsState({
    this.status = WalletsStatus.initial,
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

  final WalletsStatus status;
  final List<WalletModel> items;
  final int total;
  final int page;
  final int perPage;
  final Set<String> selectedIds;
  final WalletFilters? filters;
  final String searchQuery;
  final String? error;
  final String? successMessage;

  bool get isLoading => status == WalletsStatus.loading;
  bool get hasSelection => selectedIds.isNotEmpty;
  int get totalPages => (total / perPage).ceil();
  bool get hasNextPage => page < totalPages;
  bool get hasPreviousPage => page > 1;

  WalletsState copyWith({
    WalletsStatus? status,
    List<WalletModel>? items,
    int? total,
    int? page,
    int? perPage,
    Set<String>? selectedIds,
    WalletFilters? filters,
    String? searchQuery,
    String? error,
    String? successMessage,
  }) {
    return WalletsState(
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

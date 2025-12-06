/// File: lib/features/value_packs/presentation/cubits/value_packs_list_state.dart
/// Purpose: State for value packs list screen
/// Belongs To: value_packs feature
/// Customization Guide:
///    - Add new fields as needed
///    - All fields must be in copyWith and props
library;

import 'package:equatable/equatable.dart';

import '../../domain/entities/value_pack.dart';

/// State for value packs list screen.
class ValuePacksListState extends Equatable {
  const ValuePacksListState({
    this.status = ValuePacksListStatus.initial,
    this.packs = const [],
    this.filter,
    this.sort,
    this.page = 1,
    this.hasMore = true,
    this.selectedIds = const {},
    this.error,
  });

  /// Initial state.
  factory ValuePacksListState.initial() => const ValuePacksListState();

  final ValuePacksListStatus status;
  final List<ValuePack> packs;
  final String? filter;
  final String? sort;
  final int page;
  final bool hasMore;
  final Set<String> selectedIds;
  final String? error;

  /// Check if loading.
  bool get isLoading => status == ValuePacksListStatus.loading;

  /// Check if loaded.
  bool get isLoaded => status == ValuePacksListStatus.loaded;

  /// Check if has error.
  bool get hasError => error != null && error!.isNotEmpty;

  /// Copy with new values.
  ValuePacksListState copyWith({
    ValuePacksListStatus? status,
    List<ValuePack>? packs,
    String? filter,
    String? sort,
    int? page,
    bool? hasMore,
    Set<String>? selectedIds,
    String? error,
  }) {
    return ValuePacksListState(
      status: status ?? this.status,
      packs: packs ?? this.packs,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      selectedIds: selectedIds ?? this.selectedIds,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        packs,
        filter,
        sort,
        page,
        hasMore,
        selectedIds,
        error,
      ];
}

/// Status enum for value packs list.
enum ValuePacksListStatus {
  initial,
  loading,
  loaded,
  error,
  refreshing,
}


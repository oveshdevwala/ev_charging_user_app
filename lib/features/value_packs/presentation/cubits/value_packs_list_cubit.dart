/// File: lib/features/value_packs/presentation/cubits/value_packs_list_cubit.dart
/// Purpose: Cubit for managing value packs list state
/// Belongs To: value_packs feature
/// Customization Guide:
///    - Add new actions as needed
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_value_packs.dart';
import 'value_packs_list_state.dart';

/// Cubit for value packs list screen.
class ValuePacksListCubit extends Cubit<ValuePacksListState> {
  ValuePacksListCubit(this._getValuePacks) : super(ValuePacksListState.initial());

  final GetValuePacks _getValuePacks;

  /// Load value packs.
  Future<void> load({String? filter, String? sort}) async {
    emit(state.copyWith(
      status: ValuePacksListStatus.loading,
      filter: filter,
      sort: sort,
      page: 1,
      error: null,
    ));

    try {
      final packs = await _getValuePacks(
        filter: filter,
        sort: sort,
        page: 1,
        limit: 20,
      );

      emit(state.copyWith(
        status: ValuePacksListStatus.loaded,
        packs: packs,
        page: 1,
        hasMore: packs.length >= 20,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ValuePacksListStatus.error,
        error: e.toString(),
      ));
    }
  }

  /// Refresh value packs.
  Future<void> refresh() async {
    emit(state.copyWith(
      status: ValuePacksListStatus.refreshing,
      error: null,
    ));

    try {
      final packs = await _getValuePacks(
        filter: state.filter,
        sort: state.sort,
        page: 1,
        limit: 20,
      );

      emit(state.copyWith(
        status: ValuePacksListStatus.loaded,
        packs: packs,
        page: 1,
        hasMore: packs.length >= 20,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ValuePacksListStatus.error,
        error: e.toString(),
      ));
    }
  }

  /// Load more value packs.
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) {
      return;
    }

    emit(state.copyWith(status: ValuePacksListStatus.loading));

    try {
      final nextPage = state.page + 1;
      final packs = await _getValuePacks(
        filter: state.filter,
        sort: state.sort,
        page: nextPage,
        limit: 20,
      );

      emit(state.copyWith(
        status: ValuePacksListStatus.loaded,
        packs: [...state.packs, ...packs],
        page: nextPage,
        hasMore: packs.length >= 20,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ValuePacksListStatus.error,
        error: e.toString(),
      ));
    }
  }

  /// Apply filter.
  Future<void> applyFilter(String? filter) async {
    await load(filter: filter, sort: state.sort);
  }

  /// Apply sort.
  Future<void> applySort(String? sort) async {
    await load(filter: state.filter, sort: sort);
  }

  /// Toggle selection.
  void toggleSelection(String packId) {
    final selectedIds = Set<String>.from(state.selectedIds);
    if (selectedIds.contains(packId)) {
      selectedIds.remove(packId);
    } else {
      selectedIds.add(packId);
    }
    emit(state.copyWith(selectedIds: selectedIds));
  }
}


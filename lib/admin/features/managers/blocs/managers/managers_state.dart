/// File: lib/admin/blocs/managers/managers_state.dart
/// Purpose: Managers state
/// Belongs To: admin/blocs/managers
library;

import 'package:equatable/equatable.dart';
import 'package:ev_charging_user_app/admin/models/manager.dart';

/// Managers state.
class ManagersState extends Equatable {
  const ManagersState({
    this.isLoading = false,
    this.error,
    this.managers = const [],
    this.totalManagers = 0,
    this.currentPage = 1,
    this.pageSize = 25,
    this.searchQuery = '',
    this.filters,
    this.sortBy,
    this.sortDesc = false,
  });

  final bool isLoading;
  final String? error;
  final List<Manager> managers;
  final int totalManagers;
  final int currentPage;
  final int pageSize;
  final String searchQuery;
  final Map<String, dynamic>? filters;
  final String? sortBy;
  final bool sortDesc;

  /// Get total pages.
  int get totalPages => (totalManagers / pageSize).ceil();

  ManagersState copyWith({
    bool? isLoading,
    String? error,
    List<Manager>? managers,
    int? totalManagers,
    int? currentPage,
    int? pageSize,
    String? searchQuery,
    Map<String, dynamic>? filters,
    String? sortBy,
    bool? sortDesc,
  }) {
    return ManagersState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      managers: managers ?? this.managers,
      totalManagers: totalManagers ?? this.totalManagers,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      searchQuery: searchQuery ?? this.searchQuery,
      filters: filters ?? this.filters,
      sortBy: sortBy ?? this.sortBy,
      sortDesc: sortDesc ?? this.sortDesc,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        managers,
        totalManagers,
        currentPage,
        pageSize,
        searchQuery,
        filters,
        sortBy,
        sortDesc,
      ];
}


/// File: lib/admin/features/users/blocs/users/users_state.dart
/// Purpose: Users BLoC state
/// Belongs To: admin/features/users/blocs/users
library;

import 'package:equatable/equatable.dart';

import '../../../../models/admin_user.dart';

/// Users state.
class UsersState extends Equatable {
  const UsersState({
    this.isLoading = false,
    this.users = const [],
    this.totalUsers = 0,
    this.currentPage = 1,
    this.pageSize = 25,
    this.searchQuery = '',
    this.filters,
    this.sortBy,
    this.sortDesc = false,
    this.error,
    this.selectedUserIds,
  });

  final bool isLoading;
  final List<AdminUser> users;
  final int totalUsers;
  final int currentPage;
  final int pageSize;
  final String searchQuery;
  final Map<String, dynamic>? filters;
  final String? sortBy;
  final bool sortDesc;
  final String? error;
  final Set<String>? selectedUserIds;

  /// Total pages.
  int get totalPages => (totalUsers / pageSize).ceil();

  UsersState copyWith({
    bool? isLoading,
    List<AdminUser>? users,
    int? totalUsers,
    int? currentPage,
    int? pageSize,
    String? searchQuery,
    Map<String, dynamic>? filters,
    String? sortBy,
    bool? sortDesc,
    String? error,
    Set<String>? selectedUserIds = const {},
  }) {
    return UsersState(
      isLoading: isLoading ?? this.isLoading,
      users: users ?? this.users,
      totalUsers: totalUsers ?? this.totalUsers,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      searchQuery: searchQuery ?? this.searchQuery,
      filters: filters ?? this.filters,
      sortBy: sortBy ?? this.sortBy,
      sortDesc: sortDesc ?? this.sortDesc,
      error: error ?? this.error,
      selectedUserIds: selectedUserIds ?? this.selectedUserIds,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        users,
        totalUsers,
        currentPage,
        pageSize,
        searchQuery,
        filters,
        sortBy,
        sortDesc,
        error,
        selectedUserIds,
      ];
}


/// File: lib/admin/viewmodels/users_view_model.dart
/// Purpose: Users ViewModel for UI layer
/// Belongs To: admin/viewmodels
library;

import '../features/users/blocs/users/users_bloc.dart';
import '../features/users/blocs/users/users_event.dart';
import '../models/admin_user.dart';

/// Users ViewModel.
class UsersViewModel {
  UsersViewModel(this._bloc);

  final UsersBloc _bloc;

  /// Search users.
  void search(String query) {
    _bloc.add(UsersSearchChanged(query));
  }

  /// Apply filters.
  void applyFilters(Map<String, dynamic>? filters) {
    _bloc.add(UsersFilterChanged(filters));
  }

  /// Sort users.
  void sort(String sortBy, bool desc) {
    _bloc.add(UsersSortChanged(sortBy: sortBy, desc: desc));
  }

  /// Change page.
  void changePage(int page) {
    _bloc.add(UsersPageChanged(page));
  }

  /// Update user.
  void update(AdminUser user) {
    _bloc.add(UpdateUserEvent(user));
  }

  /// Delete user.
  void delete(String userId) {
    _bloc.add(DeleteUserEvent(userId));
  }

  /// Bulk delete users.
  void bulkDelete(List<String> userIds) {
    _bloc.add(BulkDeleteUsersEvent(userIds));
  }

  /// Update user status.
  void updateStatus(String userId, String newStatus) {
    _bloc.add(UpdateUserStatusEvent(userId: userId, newStatus: newStatus));
  }

  /// Bulk update status.
  void bulkUpdateStatus(List<String> userIds, String newStatus) {
    _bloc.add(BulkUpdateStatusEvent(userIds: userIds, newStatus: newStatus));
  }

  /// Toggle user selection.
  void toggleSelection(String userId) {
    _bloc.add(ToggleUserSelectionEvent(userId));
  }

  /// Select all users.
  void selectAll() {
    _bloc.add(const SelectAllUsersEvent());
  }

  /// Clear selection.
  void clearSelection() {
    _bloc.add(const ClearSelectionEvent());
  }
}


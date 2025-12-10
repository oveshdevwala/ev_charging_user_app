/// File: lib/admin/features/users/blocs/users/users_event.dart
/// Purpose: Users BLoC events
/// Belongs To: admin/features/users/blocs/users
library;

import 'package:equatable/equatable.dart';

import '../../../../models/admin_user.dart';

/// Base class for users events.
abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

/// Load users event.
class LoadUsers extends UsersEvent {
  const LoadUsers();
}

/// Search users event.
class UsersSearchChanged extends UsersEvent {
  const UsersSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Filter users event.
class UsersFilterChanged extends UsersEvent {
  const UsersFilterChanged(this.filters);

  final Map<String, dynamic>? filters;

  @override
  List<Object?> get props => [filters];
}

/// Sort users event.
class UsersSortChanged extends UsersEvent {
  const UsersSortChanged({
    required this.sortBy,
    required this.desc,
  });

  final String sortBy;
  final bool desc;

  @override
  List<Object?> get props => [sortBy, desc];
}

/// Page changed event.
class UsersPageChanged extends UsersEvent {
  const UsersPageChanged(this.page);

  final int page;

  @override
  List<Object?> get props => [page];
}

/// Update user event.
class UpdateUserEvent extends UsersEvent {
  const UpdateUserEvent(this.user);

  final AdminUser user;

  @override
  List<Object?> get props => [user];
}

/// Delete user event.
class DeleteUserEvent extends UsersEvent {
  const DeleteUserEvent(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

/// Bulk delete users event.
class BulkDeleteUsersEvent extends UsersEvent {
  const BulkDeleteUsersEvent(this.userIds);

  final List<String> userIds;

  @override
  List<Object?> get props => [userIds];
}

/// Update user status event.
class UpdateUserStatusEvent extends UsersEvent {
  const UpdateUserStatusEvent({
    required this.userId,
    required this.newStatus,
  });

  final String userId;
  final String newStatus;

  @override
  List<Object?> get props => [userId, newStatus];
}

/// Bulk update status event.
class BulkUpdateStatusEvent extends UsersEvent {
  const BulkUpdateStatusEvent({
    required this.userIds,
    required this.newStatus,
  });

  final List<String> userIds;
  final String newStatus;

  @override
  List<Object?> get props => [userIds, newStatus];
}

/// Toggle user selection event.
class ToggleUserSelectionEvent extends UsersEvent {
  const ToggleUserSelectionEvent(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

/// Select all users event.
class SelectAllUsersEvent extends UsersEvent {
  const SelectAllUsersEvent();
}

/// Clear selection event.
class ClearSelectionEvent extends UsersEvent {
  const ClearSelectionEvent();
}


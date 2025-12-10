/// File: lib/admin/features/users/blocs/users/users_bloc.dart
/// Purpose: Users BLoC for managing users state
/// Belongs To: admin/features/users/blocs/users
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repositories/local_user_repository.dart';
import 'users_event.dart';
import 'users_state.dart';

/// Users BLoC.
class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc({
    LocalUserRepository? repository,
  })  : _repository = repository ?? LocalUserRepository(),
        super(UsersState()) {
    on<LoadUsers>(_onLoadUsers);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
    on<BulkDeleteUsersEvent>(_onBulkDeleteUsers);
    on<UpdateUserStatusEvent>(_onUpdateUserStatus);
    on<BulkUpdateStatusEvent>(_onBulkUpdateStatus);
    on<UsersSearchChanged>(_onSearchChanged);
    on<UsersFilterChanged>(_onFilterChanged);
    on<UsersSortChanged>(_onSortChanged);
    on<UsersPageChanged>(_onPageChanged);
    on<ToggleUserSelectionEvent>(_onToggleSelection);
    on<SelectAllUsersEvent>(_onSelectAll);
    on<ClearSelectionEvent>(_onClearSelection);
  }

  final LocalUserRepository _repository;

  Future<void> _onLoadUsers(
    LoadUsers event,
    Emitter<UsersState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final users = await _repository.getAll(
        page: state.currentPage,
        perPage: state.pageSize,
        q: state.searchQuery.isEmpty ? null : state.searchQuery,
        filters: state.filters,
        sortBy: state.sortBy,
        desc: state.sortDesc,
      );
      final total = await _repository.getTotalCount(
        q: state.searchQuery.isEmpty ? null : state.searchQuery,
        filters: state.filters,
      );

      emit(state.copyWith(
        isLoading: false,
        users: users,
        totalUsers: total,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<UsersState> emit,
  ) async {
    try {
      await _repository.update(event.user);
      add(const LoadUsers());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDeleteUser(
    DeleteUserEvent event,
    Emitter<UsersState> emit,
  ) async {
    try {
      await _repository.delete(event.userId);
      add(const LoadUsers());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onBulkDeleteUsers(
    BulkDeleteUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    try {
      await _repository.bulkDelete(event.userIds);
      emit(state.copyWith(selectedUserIds: {}));
      add(const LoadUsers());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onUpdateUserStatus(
    UpdateUserStatusEvent event,
    Emitter<UsersState> emit,
  ) async {
    try {
      await _repository.updateStatus(event.userId, event.newStatus);
      add(const LoadUsers());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onBulkUpdateStatus(
    BulkUpdateStatusEvent event,
    Emitter<UsersState> emit,
  ) async {
    try {
      await _repository.bulkUpdateStatus(event.userIds, event.newStatus);
      emit(state.copyWith(selectedUserIds: {}));
      add(const LoadUsers());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onSearchChanged(
    UsersSearchChanged event,
    Emitter<UsersState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query, currentPage: 1));
    add(const LoadUsers());
  }

  void _onFilterChanged(
    UsersFilterChanged event,
    Emitter<UsersState> emit,
  ) {
    emit(state.copyWith(filters: event.filters, currentPage: 1));
    add(const LoadUsers());
  }

  void _onSortChanged(
    UsersSortChanged event,
    Emitter<UsersState> emit,
  ) {
    emit(state.copyWith(
      sortBy: event.sortBy,
      sortDesc: event.desc,
      currentPage: 1,
    ));
    add(const LoadUsers());
  }

  void _onPageChanged(
    UsersPageChanged event,
    Emitter<UsersState> emit,
  ) {
    emit(state.copyWith(currentPage: event.page));
    add(const LoadUsers());
  }

  void _onToggleSelection(
    ToggleUserSelectionEvent event,
    Emitter<UsersState> emit,
  ) {
    final currentSelection = Set<String>.from(state.selectedUserIds ?? {});
    if (currentSelection.contains(event.userId)) {
      currentSelection.remove(event.userId);
    } else {
      currentSelection.add(event.userId);
    }
    emit(state.copyWith(selectedUserIds: currentSelection));
  }

  void _onSelectAll(
    SelectAllUsersEvent event,
    Emitter<UsersState> emit,
  ) {
    final allIds = state.users.map((u) => u.id).toSet();
    emit(state.copyWith(selectedUserIds: allIds));
  }

  void _onClearSelection(
    ClearSelectionEvent event,
    Emitter<UsersState> emit,
  ) {
    emit(state.copyWith(selectedUserIds: {}));
  }
}


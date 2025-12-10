/// File: lib/admin/blocs/managers/managers_bloc.dart
/// Purpose: Managers BLoC for managing managers state
/// Belongs To: admin/blocs/managers
library;

import 'package:ev_charging_user_app/admin/repositories/local_manager_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'managers_event.dart';
import 'managers_state.dart';

/// Managers BLoC.
class ManagersBloc extends Bloc<ManagersEvent, ManagersState> {
  ManagersBloc({
    LocalManagerRepository? repository,
  })  : _repository = repository ?? LocalManagerRepository(),
        super(const ManagersState()) {
    on<LoadManagers>(_onLoadManagers);
    on<CreateManagerEvent>(_onCreateManager);
    on<UpdateManagerEvent>(_onUpdateManager);
    on<DeleteManagerEvent>(_onDeleteManager);
    on<AssignStationsEvent>(_onAssignStations);
    on<ToggleStatusEvent>(_onToggleStatus);
    on<ManagersSearchChanged>(_onSearchChanged);
    on<ManagersFilterChanged>(_onFilterChanged);
    on<ManagersSortChanged>(_onSortChanged);
    on<ManagersPageChanged>(_onPageChanged);
  }

  final LocalManagerRepository _repository;

  Future<void> _onLoadManagers(
    LoadManagers event,
    Emitter<ManagersState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final managers = await _repository.getAll(
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
        managers: managers,
        totalManagers: total,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onCreateManager(
    CreateManagerEvent event,
    Emitter<ManagersState> emit,
  ) async {
    try {
      await _repository.create(event.manager);
      add(const LoadManagers());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onUpdateManager(
    UpdateManagerEvent event,
    Emitter<ManagersState> emit,
  ) async {
    try {
      await _repository.update(event.manager);
      add(const LoadManagers());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDeleteManager(
    DeleteManagerEvent event,
    Emitter<ManagersState> emit,
  ) async {
    try {
      await _repository.delete(event.managerId);
      add(const LoadManagers());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onAssignStations(
    AssignStationsEvent event,
    Emitter<ManagersState> emit,
  ) async {
    try {
      await _repository.assignStations(event.managerId, event.stationIds);
      add(const LoadManagers());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onToggleStatus(
    ToggleStatusEvent event,
    Emitter<ManagersState> emit,
  ) async {
    try {
      await _repository.toggleStatus(event.managerId, event.newStatus);
      add(const LoadManagers());
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onSearchChanged(
    ManagersSearchChanged event,
    Emitter<ManagersState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query, currentPage: 1));
    add(const LoadManagers());
  }

  void _onFilterChanged(
    ManagersFilterChanged event,
    Emitter<ManagersState> emit,
  ) {
    emit(state.copyWith(filters: event.filters, currentPage: 1));
    add(const LoadManagers());
  }

  void _onSortChanged(
    ManagersSortChanged event,
    Emitter<ManagersState> emit,
  ) {
    emit(state.copyWith(
      sortBy: event.sortBy,
      sortDesc: event.desc,
      currentPage: 1,
    ));
    add(const LoadManagers());
  }

  void _onPageChanged(
    ManagersPageChanged event,
    Emitter<ManagersState> emit,
  ) {
    emit(state.copyWith(currentPage: event.page));
    add(const LoadManagers());
  }
}


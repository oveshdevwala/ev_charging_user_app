/// File: lib/admin/features/sessions/presentation/bloc/sessions_list_bloc.dart
/// Purpose: BLoC managing sessions list, filters, pagination, exports
/// Belongs To: admin/features/sessions
/// Customization Guide:
///    - Extend filters for new dimensions
///    - Wire to analytics hooks for table interactions
library;

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/session_models.dart';
import '../../domain/sessions_usecases.dart';

part 'sessions_list_event.dart';
part 'sessions_list_state.dart';

/// Sessions list bloc.
class SessionsListBloc extends Bloc<SessionsListEvent, SessionsListState> {
  SessionsListBloc({
    required this.getSessions,
    required this.exportSessions,
  }) : super(const SessionsListState()) {
    on<SessionsLoadRequested>(_onLoadRequested);
    on<SessionsFiltersChanged>(_onFiltersChanged);
    on<SessionsSearchChanged>(_onSearchChanged);
    on<SessionsLoadMoreRequested>(_onLoadMore);
    on<SessionsRefreshRequested>(_onRefresh);
    on<SessionsExportRequested>(_onExport);
    on<SessionsSelectionToggled>(_onSelection);
  }

  final GetSessionsUseCase getSessions;
  final ExportSessionsUseCase exportSessions;

  Future<void> _onLoadRequested(
    SessionsLoadRequested event,
    Emitter<SessionsListState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final result = await getSessions(
        cursor: null,
        limit: state.pageSize,
        filters: state.filters,
      );
      emit(
        state.copyWith(
          isLoading: false,
          sessions: result.items,
          cursor: result.nextCursor,
          hasMore: result.hasMore,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onFiltersChanged(
    SessionsFiltersChanged event,
    Emitter<SessionsListState> emit,
  ) async {
    emit(state.copyWith(filters: event.filters));
    add(const SessionsLoadRequested());
  }

  Future<void> _onSearchChanged(
    SessionsSearchChanged event,
    Emitter<SessionsListState> emit,
  ) async {
    final newFilters = Map<String, dynamic>.from(state.filters)
      ..['query'] = event.query;
    emit(state.copyWith(filters: newFilters));
    add(const SessionsLoadRequested());
  }

  Future<void> _onLoadMore(
    SessionsLoadMoreRequested event,
    Emitter<SessionsListState> emit,
  ) async {
    if (!state.hasMore || state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    try {
      final result = await getSessions(
        cursor: state.cursor,
        limit: state.pageSize,
        filters: state.filters,
      );
      emit(
        state.copyWith(
          isLoading: false,
          sessions: [...state.sessions, ...result.items],
          cursor: result.nextCursor,
          hasMore: result.hasMore,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onRefresh(
    SessionsRefreshRequested event,
    Emitter<SessionsListState> emit,
  ) async {
    add(const SessionsLoadRequested());
  }

  Future<void> _onExport(
    SessionsExportRequested event,
    Emitter<SessionsListState> emit,
  ) async {
    emit(state.copyWith(isExporting: true));
    try {
      await exportSessions(ids: state.selectedIds.toList(), format: event.format);
      emit(state.copyWith(isExporting: false));
    } catch (e) {
      emit(state.copyWith(isExporting: false, error: e.toString()));
    }
  }

  void _onSelection(
    SessionsSelectionToggled event,
    Emitter<SessionsListState> emit,
  ) {
    final updated = Set<String>.from(state.selectedIds);
    if (updated.contains(event.sessionId)) {
      updated.remove(event.sessionId);
    } else {
      updated.add(event.sessionId);
    }
    emit(state.copyWith(selectedIds: updated));
  }
}


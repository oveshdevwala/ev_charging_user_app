part of 'sessions_list_bloc.dart';

/// Base event.
abstract class SessionsListEvent extends Equatable {
  const SessionsListEvent();

  @override
  List<Object?> get props => [];
}

/// Initial load.
class SessionsLoadRequested extends SessionsListEvent {
  const SessionsLoadRequested();
}

/// Filters changed.
class SessionsFiltersChanged extends SessionsListEvent {
  const SessionsFiltersChanged(this.filters);

  final Map<String, dynamic> filters;

  @override
  List<Object?> get props => [filters];
}

/// Search query changed.
class SessionsSearchChanged extends SessionsListEvent {
  const SessionsSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Load more pages.
class SessionsLoadMoreRequested extends SessionsListEvent {
  const SessionsLoadMoreRequested();
}

/// Pull-to-refresh.
class SessionsRefreshRequested extends SessionsListEvent {
  const SessionsRefreshRequested();
}

/// Export selected rows.
class SessionsExportRequested extends SessionsListEvent {
  const SessionsExportRequested(this.format);

  final String format;

  @override
  List<Object?> get props => [format];
}

/// Toggle selected session.
class SessionsSelectionToggled extends SessionsListEvent {
  const SessionsSelectionToggled(this.sessionId);

  final String sessionId;

  @override
  List<Object?> get props => [sessionId];
}


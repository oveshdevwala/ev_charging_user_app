/// File: lib/features/search/presentation/bloc/search_event.dart
/// Purpose: Events for SearchBloc
/// Belongs To: search feature
library;

import 'package:equatable/equatable.dart';

import '../../domain/station_usecases.dart';

/// Base class for search events.
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// Search started event.
class SearchStarted extends SearchEvent {
  const SearchStarted();
}

/// Search query changed event.
class SearchQueryChanged extends SearchEvent {
  const SearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Filters applied event.
class FiltersApplied extends SearchEvent {
  const FiltersApplied(this.filters);

  final StationFilters filters;

  @override
  List<Object?> get props => [filters];
}

/// Refresh requested event.
class RefreshRequested extends SearchEvent {
  const RefreshRequested();
}

/// Clear search event.
class ClearSearch extends SearchEvent {
  const ClearSearch();
}


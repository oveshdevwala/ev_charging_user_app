/// File: lib/features/search/presentation/bloc/search_state.dart
/// Purpose: States for SearchBloc
/// Belongs To: search feature
library;

import 'package:equatable/equatable.dart';

import '../../../../models/station_model.dart';
import '../../domain/station_usecases.dart';

/// Base class for search states.
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Initial search state.
class SearchInitial extends SearchState {
  const SearchInitial();
}

/// Search loading state.
class SearchLoadInProgress extends SearchState {
  const SearchLoadInProgress();
}

/// Search success state.
class SearchLoadSuccess extends SearchState {
  const SearchLoadSuccess({
    required this.stations,
    this.filters,
    this.query,
  });

  final List<StationModel> stations;
  final StationFilters? filters;
  final String? query;

  SearchLoadSuccess copyWith({
    List<StationModel>? stations,
    StationFilters? filters,
    String? query,
  }) {
    return SearchLoadSuccess(
      stations: stations ?? this.stations,
      filters: filters ?? this.filters,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [stations, filters, query];
}

/// Search failure state.
class SearchLoadFailure extends SearchState {
  const SearchLoadFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}


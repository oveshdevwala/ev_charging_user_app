/// File: lib/features/search/bloc/search_state.dart
/// Purpose: Search page state for BLoC
/// Belongs To: search feature
library;

import 'package:equatable/equatable.dart';

import '../../../models/station_model.dart';

/// Search page state.
class SearchState extends Equatable {
  const SearchState({
    this.isLoading = false,
    this.stations = const [],
    this.query = '',
    this.error,
  });

  final bool isLoading;
  final List<StationModel> stations;
  final String query;
  final String? error;

  /// Initial state.
  factory SearchState.initial() => const SearchState();

  /// Copy with new values.
  SearchState copyWith({
    bool? isLoading,
    List<StationModel>? stations,
    String? query,
    String? error,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      stations: stations ?? this.stations,
      query: query ?? this.query,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, stations, query, error];
}


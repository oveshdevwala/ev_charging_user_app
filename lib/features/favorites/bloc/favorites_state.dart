/// File: lib/features/favorites/bloc/favorites_state.dart
/// Purpose: Favorites page state for BLoC
/// Belongs To: favorites feature
library;

import 'package:equatable/equatable.dart';

import '../../../models/station_model.dart';

/// Favorites page state.
class FavoritesState extends Equatable {
  const FavoritesState({
    this.isLoading = false,
    this.favorites = const [],
    this.error,
  });

  /// Initial state.
  factory FavoritesState.initial() => const FavoritesState(isLoading: true);

  final bool isLoading;
  final List<StationModel> favorites;
  final String? error;

  /// Copy with new values.
  FavoritesState copyWith({
    bool? isLoading,
    List<StationModel>? favorites,
    String? error,
  }) {
    return FavoritesState(
      isLoading: isLoading ?? this.isLoading,
      favorites: favorites ?? this.favorites,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, favorites, error];
}


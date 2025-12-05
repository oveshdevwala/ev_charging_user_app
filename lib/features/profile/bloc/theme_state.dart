/// File: lib/features/profile/bloc/theme_state.dart
/// Purpose: Theme BLoC state
/// Belongs To: profile feature
library;

import 'package:equatable/equatable.dart';

import '../models/models.dart';

/// Theme state.
class ThemeState extends Equatable {
  const ThemeState({
    this.isLoading = false,
    this.themeMode = ThemeModeOption.system,
    this.error,
  });

  /// Initial state.
  factory ThemeState.initial() => const ThemeState();

  final bool isLoading;
  final ThemeModeOption themeMode;
  final String? error;

  /// Copy with new values.
  ThemeState copyWith({
    bool? isLoading,
    ThemeModeOption? themeMode,
    String? error,
  }) {
    return ThemeState(
      isLoading: isLoading ?? this.isLoading,
      themeMode: themeMode ?? this.themeMode,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, themeMode, error];
}

